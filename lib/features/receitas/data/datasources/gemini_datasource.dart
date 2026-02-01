import 'dart:convert';
import 'dart:io';
import 'package:app_receitas/app/env.dart';
import 'package:app_receitas/features/receitas/data/datasources/i_receita_llm_datasource.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiDatasource implements IReceitaLLMDatasource {
  @override
  Future<Map<String, dynamic>?> gerarReceita(String comando,
      {List<String>? filtros, String? caminhoImagem}) async {
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

    final condicao = {
      false: () => "",
      true: () =>
          "Respeite estritamente estas restrições alimentares: ${filtros!.join(', ')}."
    };

    final contemFiltros = filtros != null && filtros.isNotEmpty;
    final restricao = condicao[contemFiltros]!();

    
    final prompt = '''
      Analise o pedido e/ou a imagem enviada. 
      Se NÃO FOR sobre comida, retorne um JSON com o campo isFood igual a False e outros campos vazios ou nulos.
      Se FOR relacinadi a comida, aja como um chef experiente e crie uma receita.
      $restricao
           
      Responda APENAS com um JSON seguindo este esquema exato, sem markdown:
      {
        "isFood": true,
        "titulo": "Nome do Prato",
        "tempoPreparo": "ex: 45 min",
        "ingredientes": ["Ingrediente 1", "Ingrediente 2"],
        "modoPreparo": ["Passo 1", "Passo 2"]
      }
      
      Pedido: "$comando".
      ${caminhoImagem != null ? "Imagem: $caminhoImagem" : ""}
    ''';

    List<Part> parts = [TextPart(prompt)];

    if (caminhoImagem != null) {
      final file = File(caminhoImagem);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        parts.add(DataPart('image/jpeg', bytes));
      }
    }

    // configurações de retry com exponential backoff 
    int retryCount = 0;
    const maxRetries = 5;
    final delays = [1000, 2000, 4000, 8000, 16000]; 

    while (retryCount <= maxRetries) {
      try {
        final response = await model.generateContent([Content.multi(parts)]);

        if (response.text != null) {
          return jsonDecode(response.text!);
        }
        
        
        return null;
      } catch (e) {
        
        if (retryCount >= maxRetries) {
          
          print('Não foi possível obter resposta do Gemini após $maxRetries tentativas.');
          return null;
        }

        
        await Future.delayed(Duration(milliseconds: delays[retryCount]));
        retryCount++;
        
        
        continue;
      }
    }

    return null;
  }
}