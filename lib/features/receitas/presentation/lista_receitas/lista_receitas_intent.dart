import 'package:equatable/equatable.dart';

/// Classe base abstrata para todos os intents da tela de lista.
abstract class ListaReceitasIntent extends Equatable {
  const ListaReceitasIntent();

  @override
  List<Object> get props => [];
}

/// Intent disparado quando a view é carregada pela primeira vez.
class CarregarReceitasIntent extends ListaReceitasIntent {}

/// Intent disparado quando o usuário tenta deletar uma receita.
class DeletarReceitaIntent extends ListaReceitasIntent {
  final String idDaReceita;

  const DeletarReceitaIntent(this.idDaReceita);

  @override
  List<Object> get props => [idDaReceita];
}
