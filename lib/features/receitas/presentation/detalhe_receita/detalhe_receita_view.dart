import 'dart:io';
import 'package:app_receitas/features/receitas/data/models/receita_model.dart';
import 'package:flutter/material.dart';
import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:app_receitas/features/receitas/presentation/form_receita/form_receita_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetalheReceitaView extends StatelessWidget {
  final String receitaId;

  const DetalheReceitaView({super.key, required this.receitaId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ReceitaModel>('receitas').listenable(),
      builder: (context, Box<ReceitaModel> box, _) {
        final model = box.get(receitaId);

        if (model == null) {
          Navigator.of(context).pop();

          return const Scaffold(
            body: Center(child: Text("Receita não encontrada.")),
          );
        }

        final receita = model.toDomain();

        return Scaffold(
          appBar: AppBar(
            title: Text(receita.titulo),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar Receita',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormReceitaView(receita: receita),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImagemDestaque(receita.caminhoImagem, receita.id),
                  _buildInfoTitulo(context, receita),
                  _buildSecao(
                    context,
                    icon: Icons.list_alt,
                    titulo: 'Ingredientes',
                    conteudo: receita.ingredientes,
                  ),
                  _buildSecao(
                    context,
                    icon: Icons.soup_kitchen_outlined,
                    titulo: 'Modo de Preparo',
                    conteudo: receita.modoPreparo,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagemDestaque(String? caminhoImagem, String id) {
    return Hero(
      tag: 'receita_imagem_$id',
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: caminhoImagem != null
              ? DecorationImage(
                  image: FileImage(File(caminhoImagem)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: caminhoImagem == null
            ? const Center(
                child: Icon(
                  Icons.restaurant_menu,
                  size: 100,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildInfoTitulo(BuildContext context, Receita receita) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            receita.titulo,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                '${receita.tempoPreparo} minutos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecao(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required String conteudo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            conteudo,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
