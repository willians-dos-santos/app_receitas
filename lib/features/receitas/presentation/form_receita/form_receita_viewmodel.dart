import 'dart:async';
import 'dart:io';

import 'package:app_receitas/features/receitas/domain/usecases/gerar_receita_ia.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/receita.dart';
import '../../domain/usecases/salvar_receita.dart';
import 'form_receita_intent.dart';
import 'form_receita_state.dart';

class FormReceitaViewModel {
  final SalvarReceitaUseCase _salvarReceitaUseCase;
  final GerarReceitaIAUseCase _gerarReceitaIAUseCase;

  final BehaviorSubject<FormReceitaState> _stateSubject;
  ValueStream<FormReceitaState> get state => _stateSubject.stream;

  final PublishSubject<FormReceitaIntent> _intentSubject;
  void despachar(FormReceitaIntent intent) {
    if (!_intentSubject.isClosed) {
      _intentSubject.add(intent);
    }
  }

  FormReceitaViewModel({
    required SalvarReceitaUseCase salvarReceitaUseCase,
    required GerarReceitaIAUseCase gerarReceitaIAUseCase,
    Receita? receitaInicial,
  }) : _salvarReceitaUseCase = salvarReceitaUseCase,
       _gerarReceitaIAUseCase = gerarReceitaIAUseCase,
       _stateSubject = BehaviorSubject<FormReceitaState>.seeded(
         FormReceitaState.initial().copyWith(
           imagemSelecionada: receitaInicial?.caminhoImagem != null
               ? File(receitaInicial!.caminhoImagem!)
               : null,
         ),
       ),
       _intentSubject = PublishSubject<FormReceitaIntent>() {
    _intentSubject.stream.listen(_processarIntent);
  }

  Future<void> _processarIntent(FormReceitaIntent evento) async {
    final currentState = _stateSubject.value;

    if (evento is GerarReceitaIAIntent) {
      _stateSubject.add(currentState.copyWith(status: FormStatus.carregando));
      
      final result = await _gerarReceitaIAUseCase(
        GerarReceitaIAParams(evento.prompt, caminhoImagem: evento.caminhoImagem),
      );

      result.fold(
        (failure) => _stateSubject.add(currentState.copyWith(
          status: FormStatus.erro,
          mensagemErro: failure.mensagem,
        )),
        (receita) {
          if (receita != null) {
            _stateSubject.add(currentState.copyWith(
              status: FormStatus.sucesso, 
              receitaGerada: receita,
            ));
          } else {
             _stateSubject.add(currentState.copyWith(
              status: FormStatus.erro,
              mensagemErro: "A IA não conseguiu gerar uma receita válida.",
            ));
          }
        },
      );
      return; 
    }

    if (evento is SalvarReceitaIntent) {
      _stateSubject.add(currentState.copyWith(status: FormStatus.carregando));
    }

    switch (evento) {
      case ImagemSelecionadaIntent intent:
        try {
          if (intent.imagem != null) {
            _stateSubject.add(
              currentState.copyWith(
                status: FormStatus.sucesso,
                imagemSelecionada: intent.imagem!,
              ),
            );
          } else {
            _stateSubject.add(
              currentState.copyWith(status: FormStatus.sucesso),
            );
          }
        } catch (e) {
          _stateSubject.add(
            currentState.copyWith(
              status: FormStatus.erro,
              mensagemErro: "Falha ao processar imagem: ${e.toString()}",
            ),
          );
        }
        break;

      case SalvarReceitaIntent intent:
        try {
          final receitaParaSalvar = intent.receita;

          final result = await _salvarReceitaUseCase(
            SalvarReceitaParams(receita: receitaParaSalvar),
          );

          result.fold(
            (falha) => _stateSubject.add(
              currentState.copyWith(
                status: FormStatus.erro,
                mensagemErro: "Erro ao salvar: ${falha.mensagem}",
              ),
            ),
            (_) => _stateSubject.add(
              currentState.copyWith(status: FormStatus.salvoComSucesso),
            ),
          );
        } catch (e) {
          _stateSubject.add(
            currentState.copyWith(
              status: FormStatus.erro,
              mensagemErro: "Erro inesperado: ${e.toString()}",
            ),
          );
        }
        break;
    }
  }

  void dispose() {
    _stateSubject.close();
    _intentSubject.close();
  }
}
