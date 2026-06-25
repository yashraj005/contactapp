// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firstnameMeta = const VerificationMeta(
    'firstname',
  );
  @override
  late final GeneratedColumn<String> firstname = GeneratedColumn<String>(
    'firstname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastnameMeta = const VerificationMeta(
    'lastname',
  );
  @override
  late final GeneratedColumn<String> lastname = GeneratedColumn<String>(
    'lastname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mobileNumberMeta = const VerificationMeta(
    'mobileNumber',
  );
  @override
  late final GeneratedColumn<String> mobileNumber = GeneratedColumn<String>(
    'mobile_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workNumberMeta = const VerificationMeta(
    'workNumber',
  );
  @override
  late final GeneratedColumn<String> workNumber = GeneratedColumn<String>(
    'work_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mainNumberMeta = const VerificationMeta(
    'mainNumber',
  );
  @override
  late final GeneratedColumn<String> mainNumber = GeneratedColumn<String>(
    'main_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
    'dob',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstname,
    lastname,
    email,
    mobileNumber,
    workNumber,
    phoneNumber,
    mainNumber,
    dob,
    address,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('firstname')) {
      context.handle(
        _firstnameMeta,
        firstname.isAcceptableOrUnknown(data['firstname']!, _firstnameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstnameMeta);
    }
    if (data.containsKey('lastname')) {
      context.handle(
        _lastnameMeta,
        lastname.isAcceptableOrUnknown(data['lastname']!, _lastnameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastnameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('mobile_number')) {
      context.handle(
        _mobileNumberMeta,
        mobileNumber.isAcceptableOrUnknown(
          data['mobile_number']!,
          _mobileNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mobileNumberMeta);
    }
    if (data.containsKey('work_number')) {
      context.handle(
        _workNumberMeta,
        workNumber.isAcceptableOrUnknown(data['work_number']!, _workNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_workNumberMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('main_number')) {
      context.handle(
        _mainNumberMeta,
        mainNumber.isAcceptableOrUnknown(data['main_number']!, _mainNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_mainNumberMeta);
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    } else if (isInserting) {
      context.missing(_dobMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firstname'],
      )!,
      lastname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lastname'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      mobileNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile_number'],
      )!,
      workNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_number'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      mainNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}main_number'],
      )!,
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dob'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String mobileNumber;
  final String workNumber;
  final String phoneNumber;
  final String mainNumber;
  final DateTime dob;
  final String address;
  const Contact({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobileNumber,
    required this.workNumber,
    required this.phoneNumber,
    required this.mainNumber,
    required this.dob,
    required this.address,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['firstname'] = Variable<String>(firstname);
    map['lastname'] = Variable<String>(lastname);
    map['email'] = Variable<String>(email);
    map['mobile_number'] = Variable<String>(mobileNumber);
    map['work_number'] = Variable<String>(workNumber);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['main_number'] = Variable<String>(mainNumber);
    map['dob'] = Variable<DateTime>(dob);
    map['address'] = Variable<String>(address);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      firstname: Value(firstname),
      lastname: Value(lastname),
      email: Value(email),
      mobileNumber: Value(mobileNumber),
      workNumber: Value(workNumber),
      phoneNumber: Value(phoneNumber),
      mainNumber: Value(mainNumber),
      dob: Value(dob),
      address: Value(address),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<int>(json['id']),
      firstname: serializer.fromJson<String>(json['firstname']),
      lastname: serializer.fromJson<String>(json['lastname']),
      email: serializer.fromJson<String>(json['email']),
      mobileNumber: serializer.fromJson<String>(json['mobileNumber']),
      workNumber: serializer.fromJson<String>(json['workNumber']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      mainNumber: serializer.fromJson<String>(json['mainNumber']),
      dob: serializer.fromJson<DateTime>(json['dob']),
      address: serializer.fromJson<String>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstname': serializer.toJson<String>(firstname),
      'lastname': serializer.toJson<String>(lastname),
      'email': serializer.toJson<String>(email),
      'mobileNumber': serializer.toJson<String>(mobileNumber),
      'workNumber': serializer.toJson<String>(workNumber),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'mainNumber': serializer.toJson<String>(mainNumber),
      'dob': serializer.toJson<DateTime>(dob),
      'address': serializer.toJson<String>(address),
    };
  }

  Contact copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? email,
    String? mobileNumber,
    String? workNumber,
    String? phoneNumber,
    String? mainNumber,
    DateTime? dob,
    String? address,
  }) => Contact(
    id: id ?? this.id,
    firstname: firstname ?? this.firstname,
    lastname: lastname ?? this.lastname,
    email: email ?? this.email,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    workNumber: workNumber ?? this.workNumber,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    mainNumber: mainNumber ?? this.mainNumber,
    dob: dob ?? this.dob,
    address: address ?? this.address,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      firstname: data.firstname.present ? data.firstname.value : this.firstname,
      lastname: data.lastname.present ? data.lastname.value : this.lastname,
      email: data.email.present ? data.email.value : this.email,
      mobileNumber: data.mobileNumber.present
          ? data.mobileNumber.value
          : this.mobileNumber,
      workNumber: data.workNumber.present
          ? data.workNumber.value
          : this.workNumber,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      mainNumber: data.mainNumber.present
          ? data.mainNumber.value
          : this.mainNumber,
      dob: data.dob.present ? data.dob.value : this.dob,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('firstname: $firstname, ')
          ..write('lastname: $lastname, ')
          ..write('email: $email, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('workNumber: $workNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('mainNumber: $mainNumber, ')
          ..write('dob: $dob, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstname,
    lastname,
    email,
    mobileNumber,
    workNumber,
    phoneNumber,
    mainNumber,
    dob,
    address,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.firstname == this.firstname &&
          other.lastname == this.lastname &&
          other.email == this.email &&
          other.mobileNumber == this.mobileNumber &&
          other.workNumber == this.workNumber &&
          other.phoneNumber == this.phoneNumber &&
          other.mainNumber == this.mainNumber &&
          other.dob == this.dob &&
          other.address == this.address);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> id;
  final Value<String> firstname;
  final Value<String> lastname;
  final Value<String> email;
  final Value<String> mobileNumber;
  final Value<String> workNumber;
  final Value<String> phoneNumber;
  final Value<String> mainNumber;
  final Value<DateTime> dob;
  final Value<String> address;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.firstname = const Value.absent(),
    this.lastname = const Value.absent(),
    this.email = const Value.absent(),
    this.mobileNumber = const Value.absent(),
    this.workNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.mainNumber = const Value.absent(),
    this.dob = const Value.absent(),
    this.address = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    required String firstname,
    required String lastname,
    required String email,
    required String mobileNumber,
    required String workNumber,
    required String phoneNumber,
    required String mainNumber,
    required DateTime dob,
    required String address,
  }) : firstname = Value(firstname),
       lastname = Value(lastname),
       email = Value(email),
       mobileNumber = Value(mobileNumber),
       workNumber = Value(workNumber),
       phoneNumber = Value(phoneNumber),
       mainNumber = Value(mainNumber),
       dob = Value(dob),
       address = Value(address);
  static Insertable<Contact> custom({
    Expression<int>? id,
    Expression<String>? firstname,
    Expression<String>? lastname,
    Expression<String>? email,
    Expression<String>? mobileNumber,
    Expression<String>? workNumber,
    Expression<String>? phoneNumber,
    Expression<String>? mainNumber,
    Expression<DateTime>? dob,
    Expression<String>? address,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstname != null) 'firstname': firstname,
      if (lastname != null) 'lastname': lastname,
      if (email != null) 'email': email,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (workNumber != null) 'work_number': workNumber,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (mainNumber != null) 'main_number': mainNumber,
      if (dob != null) 'dob': dob,
      if (address != null) 'address': address,
    });
  }

  ContactsCompanion copyWith({
    Value<int>? id,
    Value<String>? firstname,
    Value<String>? lastname,
    Value<String>? email,
    Value<String>? mobileNumber,
    Value<String>? workNumber,
    Value<String>? phoneNumber,
    Value<String>? mainNumber,
    Value<DateTime>? dob,
    Value<String>? address,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      workNumber: workNumber ?? this.workNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mainNumber: mainNumber ?? this.mainNumber,
      dob: dob ?? this.dob,
      address: address ?? this.address,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstname.present) {
      map['firstname'] = Variable<String>(firstname.value);
    }
    if (lastname.present) {
      map['lastname'] = Variable<String>(lastname.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (mobileNumber.present) {
      map['mobile_number'] = Variable<String>(mobileNumber.value);
    }
    if (workNumber.present) {
      map['work_number'] = Variable<String>(workNumber.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (mainNumber.present) {
      map['main_number'] = Variable<String>(mainNumber.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('firstname: $firstname, ')
          ..write('lastname: $lastname, ')
          ..write('email: $email, ')
          ..write('mobileNumber: $mobileNumber, ')
          ..write('workNumber: $workNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('mainNumber: $mainNumber, ')
          ..write('dob: $dob, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [contacts];
}

typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> id,
      required String firstname,
      required String lastname,
      required String email,
      required String mobileNumber,
      required String workNumber,
      required String phoneNumber,
      required String mainNumber,
      required DateTime dob,
      required String address,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> id,
      Value<String> firstname,
      Value<String> lastname,
      Value<String> email,
      Value<String> mobileNumber,
      Value<String> workNumber,
      Value<String> phoneNumber,
      Value<String> mainNumber,
      Value<DateTime> dob,
      Value<String> address,
    });

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstname => $composableBuilder(
    column: $table.firstname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastname => $composableBuilder(
    column: $table.lastname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workNumber => $composableBuilder(
    column: $table.workNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mainNumber => $composableBuilder(
    column: $table.mainNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstname => $composableBuilder(
    column: $table.firstname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastname => $composableBuilder(
    column: $table.lastname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workNumber => $composableBuilder(
    column: $table.workNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mainNumber => $composableBuilder(
    column: $table.mainNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstname =>
      $composableBuilder(column: $table.firstname, builder: (column) => column);

  GeneratedColumn<String> get lastname =>
      $composableBuilder(column: $table.lastname, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get mobileNumber => $composableBuilder(
    column: $table.mobileNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workNumber => $composableBuilder(
    column: $table.workNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mainNumber => $composableBuilder(
    column: $table.mainNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
          Contact,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstname = const Value.absent(),
                Value<String> lastname = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> mobileNumber = const Value.absent(),
                Value<String> workNumber = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> mainNumber = const Value.absent(),
                Value<DateTime> dob = const Value.absent(),
                Value<String> address = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                firstname: firstname,
                lastname: lastname,
                email: email,
                mobileNumber: mobileNumber,
                workNumber: workNumber,
                phoneNumber: phoneNumber,
                mainNumber: mainNumber,
                dob: dob,
                address: address,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstname,
                required String lastname,
                required String email,
                required String mobileNumber,
                required String workNumber,
                required String phoneNumber,
                required String mainNumber,
                required DateTime dob,
                required String address,
              }) => ContactsCompanion.insert(
                id: id,
                firstname: firstname,
                lastname: lastname,
                email: email,
                mobileNumber: mobileNumber,
                workNumber: workNumber,
                phoneNumber: phoneNumber,
                mainNumber: mainNumber,
                dob: dob,
                address: address,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
      Contact,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
}
