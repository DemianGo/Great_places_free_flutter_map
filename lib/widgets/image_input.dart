import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;


class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {

  File? _storedImage;
  final imagePicker = ImagePicker();

  Future<void> _takePicture() async {
    var imageFile = await imagePicker.getImage(source: ImageSource.camera, maxWidth: 600);
    // troca valor de _storedImage p endereço de imagem e verifica se é null caso usu retorne da camera sem add
    setState(() {
      if(imageFile == null){
        return;
      }
      _storedImage = File(imageFile.path);
    });
    // temp dir, apaga coisas com tempo
    if(imageFile == null){
      return;
    }
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    // print('so file name');
    // print(fileName);
    // tempName = File(imageFile.path);
    // print('copiando aqui:');
    // print('${appDir.path}/$fileName');
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
     // print('saved image contem: ');
     // print(savedImage);

    // salva imagem usando funcao recebida no estado de add_place_screen
    widget.onSelectImage(savedImage);
  }


  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: _storedImage != null
            ? Image.file(_storedImage!,
                fit: BoxFit.cover, width: double.infinity)
            : Text('No Image Taken', textAlign: TextAlign.center,),
        alignment: Alignment.center,
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: FlatButton.icon(
          icon: Icon(Icons.camera),
          label: Text('Take Picture'),
          textColor: Theme.of(context).primaryColor,
          onPressed:_takePicture,
        ),
      ),
    ]);
  }
}
