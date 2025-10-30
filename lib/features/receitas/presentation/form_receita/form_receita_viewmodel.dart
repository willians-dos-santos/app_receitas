import 'dart:async';
import 'dart:io';
import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:app_receitas/features/receitas/domain/usecases/salvar_receita.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'form_receita_intent.dart';
import 'form_receita_state.dart';

class FormReceitaViewModel {
  final SalvarReceitaUseCase _salvarReceitaUseCase;
  final ImagePicker _imagePicker;

  final _intentStream = PublishSubject<FormReceitaIntent>();

  final _stateStream = BehaviorSubject<FormReceitaState>.seeded(
    FormReceitaState.initial(),
  );

  Stream<FormReceitaState> get state => _stateStream.stream;

  void dispatchIntent(FormReceitaIntent intent) {
    _intentStream.add(intent);
  }

  void despachar(FormReceitaIntent intent) {
    _intentStream.add(intent);
  }

  FormReceitaViewModel({
    required SalvarReceitaUseCase salvarReceita,
    required ImagePicker imagePicker,
  }) : _salvarReceitaUseCase = salvarReceita,
       _imagePicker = imagePicker {
    _intentStream.listen(_handleIntent);
  }

  void _handleIntent(FormReceitaIntent intent) async {
    if (intent is SelecionarImagemIntent) {
      await _selecionarImagem(intent.source);
    }
    if (intent is SalvarReceitaIntent) {
      await _salvarReceita(intent.receita);
    }
  }

  Future<void> _selecionarImagem(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        _stateStream.add(
          _stateStream.value.copyWith(
            status: FormStatus.ocioso,
            imagemSelecionada: File(pickedFile.path),
          ),
        );
      } else {
        _stateStream.add(
          _stateStream.value.copyWith(status: FormStatus.ocioso),
        );
      }
    } catch (e) {
      _stateStream.add(
        _stateStream.value.copyWith(
          status: FormStatus.erro,
          mensagemErro: "Falha ao selecionar imagem: $e",
        ),
      );
    }
  }

  Future<void> _salvarReceita(Receita receita) async {
    _stateStream.add(
      _stateStream.value.copyWith(status: FormStatus.carregando),
    );

    final receitaParaSalvar = receita;

    final resultado = await _salvarReceitaUseCase(
      SalvarReceitaParams(receita: receitaParaSalvar),
    );

    resultado.fold(
      (falha) => _stateStream.add(
        _stateStream.value.copyWith(
          status: FormStatus.erro,
          mensagemErro: falha.mensagem,
        ),
      ),
      (_) => _stateStream.add(
        _stateStream.value.copyWith(status: FormStatus.sucesso),
      ),
    );
  }

  void dispose() {
    _intentStream.close();
    _stateStream.close();
  }
}
