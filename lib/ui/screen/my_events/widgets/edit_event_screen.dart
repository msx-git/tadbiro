import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tadbiro/utils/exports/logics.dart';
import 'package:tadbiro/utils/exports/navigation.dart';
import 'package:tadbiro/utils/extensions/sizedbox_extension.dart';

import '../../../../data/models/event.dart';
import '../../../../utils/exports/ui.dart';
import '../add_event/place_picker_map.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key, this.event});

  final Event? event;

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  var _dateTime = DateTime.now();
  var _timeOfDay = TimeOfDay.now();
  String _placeInfo = "";
  late double? latitude;
  late double? longitude;

  File? imageFile;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        _titleController.text = widget.event!.title;
        _descriptionController.text = widget.event!.description;
        _dateController.text =
            DateFormat('EEEE, d-MMMM, yyyy').format(widget.event!.date);
        _timeController.text = DateFormat('HH:mm').format(widget.event!.date);
        _placeInfo = widget.event!.placeInfo;
        latitude = widget.event!.latitude;
        longitude = widget.event!.longitude;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final event = ModalRoute.of(context)!.settings.arguments;

    return BlocListener<EventBloc, EventStates>(
      listener: (context, state) {
        if (state is LoadingEventsState) {
          Messages.showLoadingDialog(context);
        } else if (state is LoadedEventsState) {
          navigationService.goBack();
          navigationService.goBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Tadbirni tahrirlash")),
        body: Form(
          key: _formKey,
          child: ListView(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shrinkWrap: true,
            children: [
              /// TITLE INPUT
              MyTextFormField(
                controller: _titleController,
                labelText: "Tadbir nomi",
                validator: (p0) {
                  if (p0 == null || p0.trim().isEmpty) {
                    return "Tadbir nomini kiriting.";
                  }
                  return null;
                },
              ),
              12.height,

              /// DATETIME INPUT
              MyTextFormField(
                controller: _dateController,
                labelText: "Tadbir kuni",
                suffixIcon: const Icon(Icons.calendar_month_rounded),
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    currentDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  ).then(
                    (value) {
                      if (value != null) {
                        _dateController.text =
                            DateFormat("EEEE, d-MMMM, yyyy").format(value);
                        _dateTime = value;
                      }
                    },
                  );
                },
                validator: (p0) {
                  if (p0 == null || p0.trim().isEmpty) {
                    return "Tadbir kunini belgilang.";
                  }
                  return null;
                },
              ),
              12.height,

              /// TIMEOFDAY INPUT
              MyTextFormField(
                controller: _timeController,
                labelText: "Tadbir vaqti",
                suffixIcon: const Icon(Icons.access_time),
                readOnly: true,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then(
                    (value) {
                      if (value != null) {
                        _timeController.text =
                            DateFormat("HH:mm").format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          value.hour,
                          value.minute,
                        ));
                        _timeOfDay = value;
                      }
                    },
                  );
                },
                validator: (p0) {
                  if (p0 == null || p0.trim().isEmpty) {
                    return "Tadbir vaqtini belgilang.";
                  }
                  return null;
                },
              ),
              12.height,

              /// DESCRIPTION INPUT
              MyTextFormField(
                controller: _descriptionController,
                labelText: "Tadbir haqida ma'lumot: ",
                maxLines: 3,
                validator: (p0) {
                  if (p0 == null || p0.trim().isEmpty) {
                    return "Tadbir haqida ma'lumot kiriting.";
                  }
                  return null;
                },
              ),
              12.height,

              /// IMAGE PICKING
              const Text(
                "Rasm yuklash",
                style: TextStyle(fontSize: 18),
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: openCamera,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(CupertinoIcons.camera, size: 50),
                          6.height,
                          const Text("Kameradan"),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: openGallery,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(Icons.image_outlined, size: 50),
                          6.height,
                          const Text("Galareyadan"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              12.height,
              if (imageFile != null)
                SizedBox(
                  // height: 350,
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              12.height,
              const Text(
                "Manzilni belgilash:",
                style: TextStyle(fontSize: 18),
              ),
              12.height,

              /// SETTING LOCATION INFO
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => PlacePickerMap(
                      getPlaceInfo: (String info, double lat, double long) {
                        setState(() {
                          _placeInfo = info;
                          latitude = lat;
                          longitude = long;
                        });
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Icon(Icons.place_outlined, size: 50),
                      6.height,
                      const Text("Xaritani ko'rsatish"),
                    ],
                  ),
                ),
              ),
              12.height,

              /// SHOW LOCATION ADDRESS
              RichText(
                text: TextSpan(
                  text: 'Manzil: ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: _placeInfo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              80.height,
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                (latitude != null || longitude != null)) {
              context.read<EventBloc>().add(
                    EditEventEvent(
                      id: widget.event!.id,
                      newTitle: _titleController.text.trim(),
                      newDescription: _descriptionController.text.trim(),
                      newPlaceInfo: _placeInfo,
                      newDate: DateTime(
                        _dateTime.year,
                        _dateTime.month,
                        _dateTime.day,
                        _timeOfDay.hour,
                        _timeOfDay.minute,
                      ),
                      newLatitude: latitude!,
                      newLongitude: longitude!,
                      newImageFile: imageFile!,
                      imageUrl: widget.event!.bannerImageUrl,
                    ),
                  );
              _titleController.clear();
              _descriptionController.clear();
              _placeInfo = '';
              _dateController.clear();
              _timeController.clear();
            }
          },
          label: const Text("Tahrirlash"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
