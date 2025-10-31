import 'package:app_receitas/app/di_setup.dart';
import 'package:app_receitas/features/receitas/presentation/form_receita/form_receita_view.dart';
import 'package:flutter/material.dart';
import 'dart:io'; 
import '../../domain/entities/receita.dart';
import 'lista_receitas_intent.dart';
import 'lista_receitas_state.dart';
import 'lista_receitas_viewmodel.dart';

class ListaReceitasView extends StatefulWidget {
  const ListaReceitasView({super.key});

  @override
  State<ListaReceitasView> createState() => _ListaReceitasViewState();
}

class _ListaReceitasViewState extends State<ListaReceitasView> {
  
  late final ListaReceitasViewModel viewModel;

  @override
  void initState() {
    super.initState();
   
    viewModel = getIt();
    
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Receitas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de formulário (modo NOVA RECEITA)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormReceitaView()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<ListaReceitasState>(
        
        stream: viewModel.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            
            return const Center(child: CircularProgressIndicator());
          }

          final state = snapshot.data!;

          // ---- Tratamento de Status ----

          if (state.status == ListaStatus.carregando && state.receitas.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ListaStatus.erro) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.mensagemErro ?? 'Ocorreu um erro desconhecido.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            );
          }

          if (state.status == ListaStatus.sucesso && state.receitas.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma receita cadastrada ainda.\nToque no "+" para adicionar a primeira!',
                textAlign: TextAlign.center,
              ),
            );
          }

          // ---- Estado de Sucesso (com dados) ----
          return _buildListaReceitas(state.receitas);
        },
      ),
    );
  }

  Widget _buildListaReceitas(List<Receita> receitas) {
    return ListView.builder(
      itemCount: receitas.length,
      itemBuilder: (context, index) {
        final receita = receitas[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              // Mostra a imagem ou a primeira letra do título
              backgroundImage: receita.caminhoImagem != null
                  ? FileImage(File(receita.caminhoImagem!))
                  : null,
              child: receita.caminhoImagem == null
                  ? Text(receita.titulo[0].toUpperCase())
                  : null,
            ),
            title: Text(receita.titulo),
            subtitle: Text('${receita.tempoPreparo} minutos'),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () {
                // Despacha o intent de deleção
                viewModel.despachar(DeletarReceitaIntent(receita.id));
              },
            ),
            
            onTap: () {
              // Navegar para a tela de formulário (modo edição/visualização)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FormReceitaView(receita: receita),
                ),
              );
            },
            
          ),
        );
      },
    );
  }
}

