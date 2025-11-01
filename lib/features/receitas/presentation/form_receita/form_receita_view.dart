import 'package:flutter/material.dart';
import 'package:app_receitas/app/di_setup.dart'; 
import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:uuid/uuid.dart'; 
import 'dart:io'; 
import 'package:image_picker/image_picker.dart';

import 'form_receita_viewmodel.dart';
import 'form_receita_state.dart';
import 'form_receita_intent.dart';

class FormReceitaView extends StatefulWidget {
  final Receita? receita; 

  const FormReceitaView({super.key, this.receita});

  @override
  State<FormReceitaView> createState() => _FormReceitaViewState();
}

class _FormReceitaViewState extends State<FormReceitaView> {
  late final FormReceitaViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _ingredientesController;
  late final TextEditingController _preparoController;
  late final TextEditingController _tempoPreparoController;

  File? _imagemParaExibir;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FormReceitaViewModel>();

    
    _tituloController = TextEditingController(text: widget.receita?.titulo);
    _ingredientesController =
        TextEditingController(text: widget.receita?.ingredientes);
    _preparoController =
        TextEditingController(text: widget.receita?.modoPreparo);
    
    _tempoPreparoController =
        TextEditingController(text: widget.receita?.tempoPreparo); 

    if (widget.receita?.caminhoImagem != null) {
      _imagemParaExibir = File(widget.receita!.caminhoImagem!);
    }

    
    _viewModel.state.listen((state) {
      if (state.imagemSelecionada != null) {
        setState(() {
          _imagemParaExibir = state.imagemSelecionada;
        });
      }

      if (state.status == FormStatus.sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Receita salva com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        
        
        Navigator.of(context).pop();
      }

      if (state.status == FormStatus.erro) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.mensagemErro ?? "Ocorreu um erro"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _tituloController.dispose();
    _ingredientesController.dispose();
    _preparoController.dispose();
    _tempoPreparoController.dispose();
    super.dispose();
  }

  
  String _limparTextoColado(String texto) {
    
    var textoLimpo = texto.split('\n')
        .map((linha) => linha.trim())
        .join('\n');

    
    
    
    
    final regexNumeroLinhaSeparada = RegExp(r'^(\d+)$(\n^[a-zA-ZÀ-ú])', multiLine: true);
    textoLimpo = textoLimpo.replaceAllMapped(regexNumeroLinhaSeparada, (match) {
      
      
      
      return '${match.group(1)}. ${match.group(2)!.substring(1)}';
    });

    
    
    textoLimpo = textoLimpo.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    
    return textoLimpo.trim();
  }
  


  void _tentarSalvar() {
    if (_formKey.currentState?.validate() ?? false) {
      
      
      final ingredientesLimpo = _limparTextoColado(_ingredientesController.text);
      final preparoLimpo = _limparTextoColado(_preparoController.text);
      

      final receita = Receita(
        
        id: widget.receita?.id ?? const Uuid().v4(),
        titulo: _tituloController.text,
        
        
        ingredientes: ingredientesLimpo,
        modoPreparo: preparoLimpo,
        
        tempoPreparo: _tempoPreparoController.text, 
        
        caminhoImagem: _imagemParaExibir?.path,
      );

      _viewModel.despachar(SalvarReceitaIntent(receita));
    }
  }

  
  void _mostrarOpcoesFonteImagem() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  _viewModel.despachar(
                    const SelecionarImagemIntent(ImageSource.gallery),
                  );
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  _viewModel.despachar(
                    const SelecionarImagemIntent(ImageSource.camera),
                  );
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          widget.receita == null
              ? 'Nova Receita'
              : 'Editar Receita',
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<FormReceitaState>(
          stream: _viewModel.state,
          initialData: FormReceitaState.initial(),
          builder: (context, snapshot) {
            final state = snapshot.data!;
      
            
            if (state.status == FormStatus.carregando) {
              return const Center(child: CircularProgressIndicator());
            }
      
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSeletorImagem(),
                    const SizedBox(height: 24),
                    _buildTextFormField(
                      controller: _tituloController,
                      label: 'Título',
                      icon: Icons.title,
                      textCapitalization: TextCapitalization.words, 
                    ),
                    const SizedBox(height: 16),
      
                    _buildTextFormField(
                      controller: _tempoPreparoController,
                      label: 'Tempo de Preparo (ex: 30 min)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.text,
                    ),
      
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _ingredientesController,
                      label: 'Ingredientes',
                      icon: Icons.list_alt,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline, 
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _preparoController,
                      label: 'Modo de Preparo',
                      icon: Icons.soup_kitchen_outlined,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline, 
                      textCapitalization: TextCapitalization.sentences, 

                    ),
                    const SizedBox(height: 32),

                    
                    ElevatedButton.icon(
                      onPressed: _tentarSalvar,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Receita'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  
  Widget _buildSeletorImagem() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _imagemParaExibir != null ? FileImage(_imagemParaExibir!) : null,
            child: _imagemParaExibir == null
                ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[600])
                : null,
          ),
          FloatingActionButton(
            mini: true,
            onPressed: _mostrarOpcoesFonteImagem,
            child: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none, 
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization, 
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }
}

