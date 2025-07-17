library contact_app;

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

part 'screens/dashboard.dart';
part 'screens/contacts.dart';
part 'screens/new_contact_form.dart';
part 'screens/Utils/form_field.dart';
part 'screens/Utils/form_text_field.dart';
part 'screens/Utils/contact_tile.dart';
part 'screens/Utils/contact_list_builder.dart';
part 'screens/Utils/contact_events.dart';
part 'screens/Utils/contact_bloc.dart';
part 'screens/contact_details.dart';

// db implementation
part 'db/contact_db.dart';

// models
part 'models/contact_store.dart';
part 'models/list_response.dart';

part 'repo/bloc/events.dart';
part 'repo/bloc/states.dart';
part 'repo/bloc/resource.dart';
part 'repo/bloc/list.dart';
