import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Pacote para permissões
import '../models/contact.dart';

class FileStorageHelper {
  // Função para salvar os contatos na pasta de Downloads
  Future<void> salvarContatos(List<Contact> contatos) async {
    // Solicita permissões para o armazenamento (no Android 10 ou superior)
    await _requestPermissions();

    final directory = await getExternalStorageDirectory();
    final downloadDirectory = Directory('${directory?.parent.path}/Download'); // Diretório de Downloads

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    final file = File('${downloadDirectory.path}/contatos.json');
    final contatoList = contatos.map((contact) => contact.toJson()).toList();
    final jsonString = jsonEncode(contatoList);

    await file.writeAsString(jsonString);
    print("Contatos salvos no arquivo: $jsonString");
  }

  // Função para solicitar permissões de armazenamento
  Future<void> _requestPermissions() async {
    // Verifica se a permissão foi concedida e solicita se necessário
    if (await Permission.storage.request().isGranted) {
      print("Permissão de armazenamento concedida.");
    } else {
      print("Permissão de armazenamento não concedida.");
    }
  }

  // Função auxiliar para carregar contatos do arquivo
  Future<List<Contact>> carregarContatos() async {
    try {
      final directory = await getExternalStorageDirectory();
      final downloadDirectory = Directory('${directory?.parent.path}/Download'); // Diretório de Downloads
      final file = File('${downloadDirectory.path}/contatos.json');

      if (await file.exists()) {
        final fileContents = await file.readAsString();
        final jsonList = jsonDecode(fileContents) as List;
        final contatos = jsonList.map((json) => Contact.fromJson(json)).toList();
        print("Contatos carregados: $contatos");
        return contatos;
      } else {
        print("Arquivo não encontrado.");
        return [];
      }
    } catch (e) {
      print("Erro ao carregar contatos: $e");
      return [];
    }
  }
}
