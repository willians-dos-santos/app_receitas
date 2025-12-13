import 'dart:convert';
import 'dart:io';
import 'package:app_receitas/app/env.dart';
import 'package:app_receitas/features/receitas/data/datasources/i_receita_llm_datasource.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiDatasource implements IReceitaLLMDatasource {
  // ATENÇÃO: Em um app real, use --dart-define para esconder a chave ou um backend.
  // Para testes, pode colocar direto aqui, mas não suba para o GitHub público com a chave real.  
  @override
  Future<Map<String, dynamic>?> gerarReceita(String comando, {String? caminhoImagem}) async {
    
    final model = GenerativeModel(
      model: Env.LLMmodel,
      apiKey: Env.LLMApiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );

    final prompt =
        '''
      Crie uma receita culinária baseada neste pedido: "$comando".
      ${caminhoImagem != null ? "Analise também a imagem dos ingredientes enviada." : ""}      
      Responda APENAS com um JSON seguindo este esquema exato, sem markdown:
      {
        "titulo": "Nome do Prato",
        "tempoPreparo": "ex: 45 min",
        "ingredientes": ["Ingrediente 1", "Ingrediente 2"],
        "modoPreparo": ["Passo 1", "Passo 2"]
      }
      
      Se o pedido não for sobre comida, retorne um JSON com todos os campos vazios ou nulos.
    ''';

    List<Part> parts = [TextPart(prompt)];

    // SE tiver imagem, lê os bytes e adiciona ao request
    if (caminhoImagem != null) {
      final file = File(caminhoImagem);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        // O Gemini infere o tipo, mas image/jpeg é seguro para fotos de câmera
        parts.add(DataPart('image/jpeg', bytes));
      }
    }

    try {
      
      final response = await model.generateContent([Content.multi(parts)]);

      print('Resposta Bruta: ${response.text}');

      if (response.text != null) {
        return jsonDecode(response.text!);
      }
    } catch (e) {
      print('Erro Gemini: $e');
    }
    return null;
  }
}
