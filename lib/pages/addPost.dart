import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:path/path.dart' as Path;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../pages/page_detail.dart';

class stepper_widget extends StatefulWidget {
  const stepper_widget({Key? key}) : super(key: key);

  @override
  State<stepper_widget> createState() => _stepper_widgetState();
}

class _stepper_widgetState extends State<stepper_widget> {
  bool uploading = false;
  int currentStep = 0;
  // final List<XFile> _imagesList = [];
  final List<File> _imagesList = [];
  final multiPicker = ImagePicker();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _likesController = TextEditingController();
  final TextEditingController _telContactController = TextEditingController();
  final TextEditingController _generaleController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  String _typeSelected = '';
  String _locationventeSelected = '';

  @override
  void initState() {
    super.initState();
    _typeSelected = '';
    _locationventeSelected = '';

    imgRef = FirebaseFirestore.instance.collection('Products');
    userRef = FirebaseFirestore.instance.collection('Users');
  }

  double val = 0;
  late firebase_storage.Reference ref;
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  CollectionReference imgRef = FirebaseFirestore.instance.collection('Post');

  late bool isSelected = false;

  @override
  Widget _buildLocationVente(String locavente) {
    return ElevatedButton.icon(
      onPressed: () {
        isSelected = true;
        setState(() {
          _locationventeSelected = locavente;
          print(locavente.toString());
        });
      },

      style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 500),
          backgroundColor: _locationventeSelected == locavente
              ? MaterialStateProperty.all(Colors.green)
              : null, //MaterialStateProperty.all(Colors.greenAccent),
          foregroundColor: _locationventeSelected == locavente
              ? MaterialStateProperty.all(Colors.white)
              : null),
      icon: _locationventeSelected == locavente
          ? const Icon(Icons.check)
          : Container(), //Icon(Icons.check_box_outline_blank),
      label: Text(
        locavente,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'oswald',
        ),
      ),
    );
  }

  @override
  Widget _buildType(String catego) {
    return InkWell(
      child: Container(
        //height: 45,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: _typeSelected == catego
              ? Colors.green
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            catego,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'oswald'),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = catego;
        });
      },
    );
  }

  final GlobalKey<FormState> _formStepperKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: 35,
                  child: CachedNetworkImage(
                    imageUrl: user!.photoURL.toString(),
                  ),
                )),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  user!.displayName!.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'oswald', fontSize: 22),
                ),
              ),
              const Text(
                ' Va Publier Une Annonce',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'oswald', fontSize: 17),
              ),
            ],
          )),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
          ),
        ),
        child: Center(
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepTapped: (index) {
              if (_imagesList.isEmpty) {
                return;
              } else {
                setState(() => currentStep = index);
              }
            },
            onStepContinue: () {
              if (currentStep != 2) {
                // final isValid = _formStepperKey.currentState!.validate();
                // if (!isValid) return;

                setState(() => currentStep++);
              } else {
                print('completed');
                // uploadFile().whenComplete(() =>
                //     Navigator.push(context, MaterialPageRoute(builder: (_) {
                //       return main_in();
                //     })));
              }
            },
            onStepCancel:
                currentStep == 0 ? null : () => setState(() => currentStep--),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              final isLastStep = currentStep == 2;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    if (currentStep != 0)
                      Expanded(
                          child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: const Text(
                          'Precédant',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'oswald',
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    _imagesList.isEmpty
                        ? Container()
                        : Expanded(
                            child: ElevatedButton(
                              onPressed: isLastStep
                                  ? () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return page_detail(
                                          code: _codeController.text,
                                          imagesList: _imagesList,
                                          locationventeSelected:
                                              _locationventeSelected,
                                          user: user,
                                          typeSelected: _typeSelected,
                                          itemController: _itemController.text,
                                          priceController:
                                              _priceController.text,
                                          telContactController:
                                              _telContactController.text,
                                          generaleController:
                                              _generaleController.text,
                                          descriptionController:
                                              _descriptionController.text,
                                        );
                                      }));
                                    }
                                  : details.onStepContinue,
                              child: Text(
                                isLastStep ? 'Aperçu' : 'Suivant',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'oswald',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 0,
                title: const Text(
                  'Photo(s)',
                  style: TextStyle(fontFamily: 'oswald', fontSize: 14),
                ),
                content: Column(
                  children: [
                    _imagesList.length < 4
                        ? Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  //getMultiImagesGallery();
                                  _getFromCamera();
                                },
                                clipBehavior: Clip.none,
                                child: Text(
                                  'Ajouter Moins de ${4 - _imagesList.length} Photos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'oswald', fontSize: 14),
                                ),
                              ),
                              _imagesList.length == 0
                                  ? Container()
                                  : Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _getFromCamera();
                                            },
                                            icon:
                                                Icon(Icons.camera_alt_rounded),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              getMultiImagesGallery();
                                            },
                                            icon: Icon(Icons.image),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              Fluttertoast.showToast(
                                msg: 'Devenir Premium',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                            },
                            child: const Text(
                              'Limite d\'Ajout des Photos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'oswald',
                                  fontSize: 14,
                                  color: Colors.deepOrange),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    _imagesList.isEmpty
                        ? Center(
                            child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            )),
                            height: 300,
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                getMultiImagesGallery();
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _getFromCamera();
                                      },
                                      icon: Icon(Icons.camera_alt_rounded),
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        getMultiImagesGallery();
                                      },
                                      icon: Icon(Icons.image),
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                        : GridView.builder(
                            key: UniqueKey(),
                            shrinkWrap: true,
                            itemCount:
                                _imagesList.isEmpty ? 2 : _imagesList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5))),
                                  child:
                                      // _imagesList.isEmpty
                                      //     ? InkWell(
                                      //         onTap: () {
                                      //           getMultiImages();
                                      //         },
                                      //         child: Icon(
                                      //           CupertinoIcons.camera,
                                      //           color: Colors.grey.withOpacity(0.5),
                                      //         ),
                                      //       )
                                      //     :
                                      Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(_imagesList[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Container(
                                            // color: const Colors.,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red,
                                              onPressed: () {
                                                _imagesList.removeAt(index);
                                                setState(() {});
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                  // )
                                )),
                  ],
                ),
              ),
              Step(
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 1,
                title: const Text(
                  'Details',
                  style: TextStyle(fontFamily: 'oswald', fontSize: 14),
                ),
                content: Column(
                  children: <Widget>[
                    const Text(
                      'Voulez Vous Mettre Votre Bien en Location ou le Vendre ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'oswald', fontSize: 18),
                    ),
                    const Text(
                      ' تريد وضع ممتلكاتك للكراء او للبيع ؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'NizarBBCKurdish-Bold', fontSize: 18),
                    ),
                    Form(
                      key: _formStepperKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildLocationVente('Location'),
                              )),
                              // const SizedBox(width: 10),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildLocationVente('Vente'),
                              )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                            child: SizedBox(
                              height: 35,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _buildType('Hotel'),
                                  const SizedBox(width: 5),
                                  _buildType('Residence'),
                                  const SizedBox(width: 5),
                                  _buildType('Agence'),
                                  const SizedBox(width: 5),
                                  _buildType('Autres'),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _codeController,
                            decoration: const InputDecoration(
                              hintText: 'Code',
                              prefixIcon: Icon(
                                Icons.abc_rounded,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: false,
//                        contentPadding: EdgeInsets.all(15),
                            ),
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Entrer min 6 characteres.'
                                    : null,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _itemController,
                            decoration: const InputDecoration(
                              hintText: 'Titre du Produit',
                              prefixIcon: Icon(
                                Icons.view_in_ar_rounded,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: false,
//                        contentPadding: EdgeInsets.all(15),
                            ),
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Entrer min 6 characteres.'
                                    : null,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                            decoration: const InputDecoration(
                              hintText: 'Prix Réel Jour',
                              prefixIcon: Icon(
                                Icons.monetization_on_outlined,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              //contentPadding: EdgeInsets.all(15),
                            ),
                            validator: (value) =>
                                value != null && int.parse(value) < 500
                                    ? 'Entrer Le Prix Réel'
                                    : null,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 5),
                          IntlPhoneField(
                            controller: _telContactController,
                            decoration: const InputDecoration(
                                labelText: 'Tel De Contact'
                                // border: OutlineInputBorder(
                                //   borderSide: BorderSide(),
                                // ),
                                ),

                            // disableLengthCheck: true,
                            showDropdownIcon: false,
                            initialCountryCode: 'DZ',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            flagsButtonMargin: EdgeInsets.zero,
                            flagsButtonPadding: const EdgeInsets.only(left: 15),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _generaleController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Général',
                              prefixIcon: Icon(
                                Icons.phone_iphone,
                                size: 30,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              // contentPadding: EdgeInsets.all(15),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Déscription',
                                prefixIcon: Icon(
                                  Icons.phone_iphone,
                                  size: 30,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                // contentPadding: EdgeInsets.all(15),
                              ),
                              textInputAction: TextInputAction.next),
                        ],
                      ),
                    ),
                    //CATEGORIES**********************************************************
                  ],
                ),
              ),
              Step(
                  state:
                      currentStep > 2 ? StepState.complete : StepState.indexed,
                  isActive: currentStep >= 2,
                  title: const Text(
                    'Localisation',
                    style: TextStyle(fontFamily: 'oswald', fontSize: 14),
                  ),
                  content: Center(child: Text('Map'))),
            ],
          ),
        ),
      ),
    );
  }

  Future getMultiImagesGallery() async {
    final List<XFile>? selectedImages = (await multiPicker.pickMultiImage(
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    ));

    setState(() {
      if (_imagesList.length <= 4) {
        if (selectedImages!.length <= (4 - _imagesList.length)) {
          // _imagesList.addAll(selectedImages);
          _imagesList.addAll(
              selectedImages.map<File>((XFile) => File(XFile.path)).toList());
          return print('PLUS QUE 4');
        } else {
          print('No Images Selected ');
          Fluttertoast.showToast(
              msg: (4 - _imagesList.length) == 1
                  ? 'Selectionner 1 Photo'
                  : 'Selectionner ${4 - _imagesList.length} Photo(s) ou Moins',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Pas De 4 Photos',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 14.0);
        return print('PAS PLUS QUE 4');
      }
    });
  }

  /// Get from camera
  Future _getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }

    setState(() {
      List<XFile> selectedImages = [];
      selectedImages.add(pickedFile!);

      if (_imagesList.length <= 4) {
        if (selectedImages.length <= (4 - _imagesList.length)) {
          // _imagesList.addAll(selectedImages);
          _imagesList.addAll(
              selectedImages.map<File>((XFile) => File(XFile.path)).toList());
          return print('PLUS QUE 4');
        } else {
          print('No Images Selected ');
          Fluttertoast.showToast(
              msg: (4 - _imagesList.length) == 1
                  ? 'Selectionner 1 Photo'
                  : 'Selectionner ${4 - _imagesList.length} Photo(s) ou Moins',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Pas De 4 Photos',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 14.0);
        return print('PAS PLUS QUE 4');
      }
    });
  }

  Future getMultiImagesCamera() async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage(
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

    setState(() {
      if (_imagesList.length <= 4) {
        if (selectedImages!.length <= (4 - _imagesList.length)) {
          // _imagesList.addAll(selectedImages);
          _imagesList.addAll(
              selectedImages.map<File>((XFile) => File(XFile.path)).toList());
          return print('PLUS QUE 4');
        } else {
          print('No Images Selected ');
          Fluttertoast.showToast(
              msg: (4 - _imagesList.length) == 1
                  ? 'Selectionner 1 Photo'
                  : 'Selectionner ${4 - _imagesList.length} Photo(s) ou Moins',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Pas De 4 Photos',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 14.0);
        return print('PAS PLUS QUE 4');
      }
    });
  }
}
