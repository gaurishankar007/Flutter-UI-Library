enum DocumentType {
  images(allowedFileTypes: ['png', 'jpg', 'jpeg']),
  imagesAndPDF(allowedFileTypes: ['png', 'jpg', 'jpeg', 'pdf']);
  const DocumentType({required this.allowedFileTypes});

  final List<String> allowedFileTypes;
}
