class Contact {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? imagePath; // Caminho da imagem
  final String? photo; // Novo atributo opcional para armazenar o caminho da foto


  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
    this.photo, // Adiciona o parâmetro opcional
  });
}
