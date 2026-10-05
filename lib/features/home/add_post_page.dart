import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wahrane/features/home/add_post_detail_page.dart';

class StepperWidget extends StatefulWidget {
  StepperWidget({Key? key, required this.ccollection}) : super(key: key);
  final String ccollection;

  @override
  State<StepperWidget> createState() => _stepper_widgetState();
}

class _stepper_widgetState extends State<StepperWidget> {
  bool uploading = false;
  int currentStep = 0;
  // final List<XFile> _imagesList = [];
  final List<File> _imagesList = [];
  final multiPicker = ImagePicker();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _telContactController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  String _typeSelected = '';
  String _locationventeSelected = '';
  late int selectedRadio;
  @override
  void initState() {
    super.initState();
    _typeSelected = '';
    _locationventeSelected = '';
    selectedRadio = 0;
    //imgRef = FirebaseFirestore.instance.collection(widget.ccollection);
    userRef = FirebaseFirestore.instance.collection('Users');
  }

  double val = 0;
  late firebase_storage.Reference ref;
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  //CollectionReference imgRef = FirebaseFirestore.instance.collection('Post');

  late bool isSelected = false;
  late bool isSwitched = false;
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
              ? WidgetStateProperty.all(Colors.green)
              : null, //MaterialStateProperty.all(Colors.greenAccent),
          foregroundColor: _locationventeSelected == locavente
              ? WidgetStateProperty.all(Colors.white)
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
              // if (currentStep == 0) {
              //   setState(() => currentStep++);
              // }
              // if (currentStep == 1) {
              //   //  if (_formStepperKey.currentState!.validate()) {
              //   setState(() => currentStep++);
              //   //}
              // }
              if (currentStep != 2) {
                if (currentStep != 1) {
                  setState(() => currentStep++);
                } else {
                  if (_formStepperKey.currentState!.validate()) {
                    setState(() => currentStep++);
                  }
                }
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
                        : widget.ccollection == 'Products'
                            ? Expanded(
                                child: ElevatedButton(
                                  onPressed: isLastStep
                                      ? () async {
                                          await Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return //widget.ccollection == 'Products'
                                                // ?
                                                page_detail(
                                              //   code: _codeController.text,
                                              imagesList: _imagesList,
                                              locationventeSelected:
                                                  _locationventeSelected,
                                              user: user,
                                              typeSelected: _typeSelected,
                                              itemController:
                                                  _itemController.text,
                                              priceController:
                                                  _priceController.text,
                                              telContactController:
                                                  _telContactController.text,
                                              // generaleController:
                                              //     _generaleController.text,
                                              descriptionController:
                                                  _descriptionController.text,
                                              phoneController: int.parse(
                                                  _telContactController.text),
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
                              )
                            : Expanded(
                                child: ElevatedButton(
                                  onPressed: isLastStep
                                      ? () async {
                                          await Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return page_detail_insta(
                                              //   code: _codeController.text,
                                              imagesList: _imagesList,
                                              locationventeSelected:
                                                  _locationventeSelected,
                                              user: user,
                                              typeSelected: _typeSelected,
                                              itemController:
                                                  _itemController.text,
                                              priceController:
                                                  _priceController.text,
                                              telContactController:
                                                  _telContactController.text,
                                              // generaleController:
                                              //     _generaleController.text,
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
                                  style: const TextStyle(
                                      fontFamily: 'oswald', fontSize: 14),
                                ),
                              ),
                              _imagesList.isEmpty
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
                                                const Icon(Icons.camera_alt_rounded),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              getMultiImagesGallery();
                                            },
                                            icon: const Icon(Icons.image),
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
                              color: Colors.grey.withValues(alpha: 0.5),
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
                                      icon: const Icon(Icons.camera_alt_rounded),
                                      color: Colors.grey.withValues(alpha: 0.5),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        getMultiImagesGallery();
                                      },
                                      icon: const Icon(Icons.image),
                                      color: Colors.grey.withValues(alpha: 0.5),
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
                                          color: Colors.grey.withValues(alpha: 0.5))),
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
                          ), // location ou vente
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                          //   child: SizedBox(
                          //     height: 35,
                          //     child: ListView(
                          //       scrollDirection: Axis.horizontal,
                          //       children: [
                          //         _buildType('Hotel'),
                          //         const SizedBox(width: 5),
                          //         _buildType('Residence'),
                          //         const SizedBox(width: 5),
                          //         _buildType('Agence'),
                          //         const SizedBox(width: 5),
                          //         _buildType('Autres'),
                          //         const SizedBox(width: 5),
                          //       ],
                          //     ),
                          //   ),
                          // ), // categorie
                          TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                            keyboardType: TextInputType.text,
                            controller: _itemController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Titre du Produit',
                              border: InputBorder.none,
                              filled: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Entrer min 6 characteres.'
                                    : null,
                          ), // titre du produit
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Prix',
                              border: InputBorder.none,
                              filled: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Prix Réel Jour';
                              }
                              return null;
                            },
                          ), // prix
                          const SizedBox(
                            height: 10,
                          ),
                          IntlPhoneField(
                            controller: _telContactController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              hintText: '660 00 00 00',
                              border: InputBorder.none,
                              filled: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            invalidNumberMessage:
                                'Entrer Que Ooreddo ou Djezzy ou Mobilis',
                            // disableLengthCheck: true,
                            validator: (value) {
                              if (value == null) {
                                return 'Entrer Ton Numero de Tel';
                              } else {
                                // validate against your regex pattern
                                RegExp regex = RegExp(r'^[678][0-9]{8}$');
                                if (!regex.hasMatch(value.toString())) {
                                  return 'Entrer Que Ooreddo ou Djezzy ou Mobilis';
                                }
                                return null;
                              }
                            },
                            style: const TextStyle(
                              fontSize: 25,
                            ),

                            showDropdownIcon: false,
                            initialCountryCode: 'DZ',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            flagsButtonMargin: EdgeInsets.zero,
                            flagsButtonPadding: const EdgeInsets.only(left: 15),
                          ), // mobile
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.multiline,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Ecrire Une Description',
                                border: InputBorder.none,
                                filled: true,
                                contentPadding: EdgeInsets.all(15),
                              ),
                              textInputAction:
                                  TextInputAction.next), // description
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
                  content: const Center(child: Text('Map'))),
            ],
          ),
        ),
      ),
    );
  }

  Future getMultiImagesGallery() async {
    final List<XFile> selectedImages = (await multiPicker.pickMultiImage(
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    ));

    setState(() {
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

  /// Get from camera
  Future _getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

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
    final List<XFile> selectedImages = await multiPicker.pickMultiImage(
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

    setState(() {
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
}
