import 'package:app_receitas/app/pt_br_picker_delegate.dart';
import 'package:app_receitas/features/receitas/data/datasources/i_receita_llm_datasource.dart';
import 'package:flutter/material.dart';
import 'package:app_receitas/app/di_setup.dart';
import 'package:app_receitas/features/receitas/domain/entities/receita.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:photo_manager/photo_manager.dart';
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
    _ingredientesController = TextEditingController(
      text: widget.receita?.ingredientes,
    );
    _preparoController = TextEditingController(
      text: widget.receita?.modoPreparo,
    );

    _tempoPreparoController = TextEditingController(
      text: widget.receita?.tempoPreparo,
    );

    if (widget.receita?.caminhoImagem != null) {
      _imagemParaExibir = File(widget.receita!.caminhoImagem!);
    }

    _viewModel.state.listen((state) {
      if (state.imagemSelecionada != null) {
        setState(() {
          _imagemParaExibir = state.imagemSelecionada!;
        });
      }

      if (state.status == FormStatus.salvoComSucesso) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Receita salva com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }

      if (state.status == FormStatus.erro) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.mensagemErro ?? "Ocorreu um erro"),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (state.receitaGerada != null) {
        
        _tituloController.text = state.receitaGerada!.titulo;
        _tempoPreparoController.text = state.receitaGerada!.tempoPreparo;
        _ingredientesController.text = state.receitaGerada!.ingredientes;
        _preparoController.text = state.receitaGerada!.modoPreparo;
        
        
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita preenchida pela IA! 🪄')),
          );
        }
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
    var textoLimpo = texto
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join('\n');

    final regexNumeroLinhaSeparada = RegExp(
      r'^(\d+)$(\n^[a-zA-ZÀ-ú])',
      multiLine: true,
    );
    textoLimpo = textoLimpo.replaceAllMapped(regexNumeroLinhaSeparada, (match) {
      return '${match.group(1)}. ${match.group(2)!.substring(1)}';
    });

    textoLimpo = textoLimpo.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return textoLimpo.trim();
  }

  void _tentarSalvar() {
    if (_formKey.currentState?.validate() ?? false) {
      final ingredientesLimpo = _limparTextoColado(
        _ingredientesController.text,
      );
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

  Future<void> _chamarPicker(FonteImagem fonte) async {
    if (mounted) Navigator.of(context).pop();

    try {
      final AssetEntity? entity;
      final textDelegate = PtBrPickerDelegate();
      if (fonte == FonteImagem.camera) {
        entity = await CameraPicker.pickFromCamera(
          context,
          pickerConfig: CameraPickerConfig(
            textDelegate: textDelegate,
            preferredLensDirection: CameraLensDirection.back,
            resolutionPreset: ResolutionPreset.ultraHigh,
          ),
        );
      } else {
        final List<AssetEntity>? entities = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            textDelegate: textDelegate,
            maxAssets: 1,
            requestType: RequestType.image,
          ),
        );
        entity = entities?.firstOrNull;
      }

      if (entity == null) {
        _viewModel.despachar(ImagemSelecionadaIntent(null));
        return;
      }

      final File? file = await entity.originFile;

      _viewModel.despachar(ImagemSelecionadaIntent(file));
    } catch (e) {
      _viewModel.despachar(ImagemSelecionadaIntent(null));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao usar a câmara: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarOpcoesFonteImagem() {
    if (!mounted) return;

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
                  _chamarPicker(FonteImagem.galeria);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  _chamarPicker(FonteImagem.camera);
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
        title: Text(widget.receita == null ? 'Nova Receita' : 'Editar Receita'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.auto_awesome,
              color: Colors.purple,
            ), // Ícone de "mágica"
            tooltip: 'Criar com IA',
            onPressed: _abrirGeradorIA,
          ),
        ],
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
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      controller: _tempoPreparoController,
                      label: 'Tempo de Preparo (ex: 30 min)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _ingredientesController,
                      label: 'Ingredientes',
                      icon: Icons.list_alt,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _preparoController,
                      label: 'Modo de Preparo',
                      icon: Icons.soup_kitchen_outlined,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
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
            backgroundImage: _imagemParaExibir != null
                ? FileImage(_imagemParaExibir!)
                : null,
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
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }

  Future<void> _abrirGeradorIA() async {
    final controllerPrompt = TextEditingController();

    final temImagem = _imagemParaExibir != null;



    final comando = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✨ Chef IA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Descreva o que quer comer ou os ingredientes.'),
            if (temImagem) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: const [
                    Icon(Icons.image, size: 16, color: Colors.green),
                    SizedBox(width: 5),
                    Expanded(child: Text("Vou usar a foto selecionada também!", style: TextStyle(fontSize: 12, color: Colors.green))),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: controllerPrompt,
              decoration: const InputDecoration(
                hintText: 'Ex: O que posso fazer com isso?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controllerPrompt.text),
            child: const Text('Gerar Mágica'),
          ),
        ],
      ),
    );

    if (comando != null && comando.isNotEmpty) {
     _viewModel.despachar(
      GerarReceitaIAIntent(
        comando,
        caminhoImagem: temImagem ? _imagemParaExibir!.path : null,
        )
      );
    }
  }

}
