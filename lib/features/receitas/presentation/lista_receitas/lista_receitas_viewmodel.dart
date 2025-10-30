import 'dart:async';
import 'package:app_receitas/features/receitas/domain/usecases/get_todas_receitas.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/deletar_receita.dart';
import 'lista_receitas_intent.dart';
import 'lista_receitas_state.dart';

class ListaReceitasViewModel {
  final GetTodasReceitasUseCase _getTodasReceitas;
  final DeletarReceitaUseCase _ucDeletarReceita;

  final _stateController = BehaviorSubject<ListaReceitasState>.seeded(
    const ListaReceitasState(),
  );

  Stream<ListaReceitasState> get state => _stateController.stream;

  StreamSubscription? _receitasSubscription;

  ListaReceitasViewModel({
    required GetTodasReceitasUseCase getTodasReceitas,
    required DeletarReceitaUseCase deletarReceita,
  }) : _getTodasReceitas = getTodasReceitas,
       _ucDeletarReceita = deletarReceita {
    despachar(CarregarReceitasIntent());
  }

  void despachar(ListaReceitasIntent intent) {
    if (intent is CarregarReceitasIntent) {
      _carregarReceitas();
    } else if (intent is DeletarReceitaIntent) {
      _deletarReceita(intent.idDaReceita);
    }
  }

  void _carregarReceitas() {
    _receitasSubscription?.cancel();

    _emitState(_stateController.value.copyWith(status: ListaStatus.carregando));

    _receitasSubscription = _getTodasReceitas().listen(
      (receitas) {
        _emitState(
          _stateController.value.copyWith(
            status: ListaStatus.sucesso,
            receitas: receitas,
          ),
        );
      },
      onError: (e) {
        _emitState(
          _stateController.value.copyWith(
            status: ListaStatus.erro,
            mensagemErro: 'Falha ao carregar receitas: $e',
          ),
        );
      },
    );
  }

  Future<void> _deletarReceita(String id) async {
    try {
      await _ucDeletarReceita(DeletarReceitaParams(id: id));
    } catch (e) {
      print('Erro ao deletar: $e');
    }
  }

  void _emitState(ListaReceitasState newState) {
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  void dispose() {
    _receitasSubscription?.cancel();
    _stateController.close();
  }
}
