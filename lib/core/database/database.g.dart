// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
      'frequency', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _customDaysMeta =
      const VerificationMeta('customDays');
  @override
  late final GeneratedColumn<String> customDays = GeneratedColumn<String>(
      'custom_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _targetCountMeta =
      const VerificationMeta('targetCount');
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
      'target_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderEnabledMeta =
      const VerificationMeta('reminderEnabled');
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        emoji,
        category,
        priority,
        frequency,
        customDays,
        description,
        colorHex,
        targetCount,
        reminderTime,
        reminderEnabled,
        sortOrder,
        isArchived,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<HabitEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('custom_days')) {
      context.handle(
          _customDaysMeta,
          customDays.isAcceptableOrUnknown(
              data['custom_days']!, _customDaysMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('target_count')) {
      context.handle(
          _targetCountMeta,
          targetCount.isAcceptableOrUnknown(
              data['target_count']!, _targetCountMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
          _reminderEnabledMeta,
          reminderEnabled.isAcceptableOrUnknown(
              data['reminder_enabled']!, _reminderEnabledMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency'])!,
      customDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_days']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      targetCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_count'])!,
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_time']),
      reminderEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class HabitEntity extends DataClass implements Insertable<HabitEntity> {
  final int id;
  final String name;
  final String emoji;
  final int category;
  final int priority;
  final int frequency;
  final String? customDays;
  final String? description;
  final String colorHex;
  final int targetCount;
  final String? reminderTime;
  final bool reminderEnabled;
  final int sortOrder;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HabitEntity(
      {required this.id,
      required this.name,
      required this.emoji,
      required this.category,
      required this.priority,
      required this.frequency,
      this.customDays,
      this.description,
      required this.colorHex,
      required this.targetCount,
      this.reminderTime,
      required this.reminderEnabled,
      required this.sortOrder,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    map['category'] = Variable<int>(category);
    map['priority'] = Variable<int>(priority);
    map['frequency'] = Variable<int>(frequency);
    if (!nullToAbsent || customDays != null) {
      map['custom_days'] = Variable<String>(customDays);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color_hex'] = Variable<String>(colorHex);
    map['target_count'] = Variable<int>(targetCount);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      emoji: Value(emoji),
      category: Value(category),
      priority: Value(priority),
      frequency: Value(frequency),
      customDays: customDays == null && nullToAbsent
          ? const Value.absent()
          : Value(customDays),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      colorHex: Value(colorHex),
      targetCount: Value(targetCount),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      reminderEnabled: Value(reminderEnabled),
      sortOrder: Value(sortOrder),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      category: serializer.fromJson<int>(json['category']),
      priority: serializer.fromJson<int>(json['priority']),
      frequency: serializer.fromJson<int>(json['frequency']),
      customDays: serializer.fromJson<String?>(json['customDays']),
      description: serializer.fromJson<String?>(json['description']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'category': serializer.toJson<int>(category),
      'priority': serializer.toJson<int>(priority),
      'frequency': serializer.toJson<int>(frequency),
      'customDays': serializer.toJson<String?>(customDays),
      'description': serializer.toJson<String?>(description),
      'colorHex': serializer.toJson<String>(colorHex),
      'targetCount': serializer.toJson<int>(targetCount),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HabitEntity copyWith(
          {int? id,
          String? name,
          String? emoji,
          int? category,
          int? priority,
          int? frequency,
          Value<String?> customDays = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? colorHex,
          int? targetCount,
          Value<String?> reminderTime = const Value.absent(),
          bool? reminderEnabled,
          int? sortOrder,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      HabitEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        emoji: emoji ?? this.emoji,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        frequency: frequency ?? this.frequency,
        customDays: customDays.present ? customDays.value : this.customDays,
        description: description.present ? description.value : this.description,
        colorHex: colorHex ?? this.colorHex,
        targetCount: targetCount ?? this.targetCount,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        sortOrder: sortOrder ?? this.sortOrder,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HabitEntity copyWithCompanion(HabitsCompanion data) {
    return HabitEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      customDays:
          data.customDays.present ? data.customDays.value : this.customDays,
      description:
          data.description.present ? data.description.value : this.description,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      targetCount:
          data.targetCount.present ? data.targetCount.value : this.targetCount,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('frequency: $frequency, ')
          ..write('customDays: $customDays, ')
          ..write('description: $description, ')
          ..write('colorHex: $colorHex, ')
          ..write('targetCount: $targetCount, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      emoji,
      category,
      priority,
      frequency,
      customDays,
      description,
      colorHex,
      targetCount,
      reminderTime,
      reminderEnabled,
      sortOrder,
      isArchived,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.frequency == this.frequency &&
          other.customDays == this.customDays &&
          other.description == this.description &&
          other.colorHex == this.colorHex &&
          other.targetCount == this.targetCount &&
          other.reminderTime == this.reminderTime &&
          other.reminderEnabled == this.reminderEnabled &&
          other.sortOrder == this.sortOrder &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HabitsCompanion extends UpdateCompanion<HabitEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> emoji;
  final Value<int> category;
  final Value<int> priority;
  final Value<int> frequency;
  final Value<String?> customDays;
  final Value<String?> description;
  final Value<String> colorHex;
  final Value<int> targetCount;
  final Value<String?> reminderTime;
  final Value<bool> reminderEnabled;
  final Value<int> sortOrder;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.frequency = const Value.absent(),
    this.customDays = const Value.absent(),
    this.description = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String emoji,
    required int category,
    this.priority = const Value.absent(),
    required int frequency,
    this.customDays = const Value.absent(),
    this.description = const Value.absent(),
    required String colorHex,
    this.targetCount = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        emoji = Value(emoji),
        category = Value(category),
        frequency = Value(frequency),
        colorHex = Value(colorHex),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<HabitEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<int>? category,
    Expression<int>? priority,
    Expression<int>? frequency,
    Expression<String>? customDays,
    Expression<String>? description,
    Expression<String>? colorHex,
    Expression<int>? targetCount,
    Expression<String>? reminderTime,
    Expression<bool>? reminderEnabled,
    Expression<int>? sortOrder,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (frequency != null) 'frequency': frequency,
      if (customDays != null) 'custom_days': customDays,
      if (description != null) 'description': description,
      if (colorHex != null) 'color_hex': colorHex,
      if (targetCount != null) 'target_count': targetCount,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HabitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? emoji,
      Value<int>? category,
      Value<int>? priority,
      Value<int>? frequency,
      Value<String?>? customDays,
      Value<String?>? description,
      Value<String>? colorHex,
      Value<int>? targetCount,
      Value<String?>? reminderTime,
      Value<bool>? reminderEnabled,
      Value<int>? sortOrder,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      targetCount: targetCount ?? this.targetCount,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (customDays.present) {
      map['custom_days'] = Variable<String>(customDays.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('frequency: $frequency, ')
          ..write('customDays: $customDays, ')
          ..write('description: $description, ')
          ..write('colorHex: $colorHex, ')
          ..write('targetCount: $targetCount, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $HabitCompletionsTable extends HabitCompletions
    with TableInfo<$HabitCompletionsTable, HabitCompletionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES habits (id)'));
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, habitId, count, note, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_completions';
  @override
  VerificationContext validateIntegrity(
      Insertable<HabitCompletionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {habitId, date},
      ];
  @override
  HabitCompletionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}habit_id'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $HabitCompletionsTable createAlias(String alias) {
    return $HabitCompletionsTable(attachedDatabase, alias);
  }
}

class HabitCompletionEntity extends DataClass
    implements Insertable<HabitCompletionEntity> {
  final int id;
  final DateTime date;
  final int habitId;
  final int count;
  final String? note;
  final DateTime completedAt;
  const HabitCompletionEntity(
      {required this.id,
      required this.date,
      required this.habitId,
      required this.count,
      this.note,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['habit_id'] = Variable<int>(habitId);
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(
      id: Value(id),
      date: Value(date),
      habitId: Value(habitId),
      count: Value(count),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      completedAt: Value(completedAt),
    );
  }

  factory HabitCompletionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletionEntity(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      habitId: serializer.fromJson<int>(json['habitId']),
      count: serializer.fromJson<int>(json['count']),
      note: serializer.fromJson<String?>(json['note']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'habitId': serializer.toJson<int>(habitId),
      'count': serializer.toJson<int>(count),
      'note': serializer.toJson<String?>(note),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  HabitCompletionEntity copyWith(
          {int? id,
          DateTime? date,
          int? habitId,
          int? count,
          Value<String?> note = const Value.absent(),
          DateTime? completedAt}) =>
      HabitCompletionEntity(
        id: id ?? this.id,
        date: date ?? this.date,
        habitId: habitId ?? this.habitId,
        count: count ?? this.count,
        note: note.present ? note.value : this.note,
        completedAt: completedAt ?? this.completedAt,
      );
  HabitCompletionEntity copyWithCompanion(HabitCompletionsCompanion data) {
    return HabitCompletionEntity(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      count: data.count.present ? data.count.value : this.count,
      note: data.note.present ? data.note.value : this.note,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionEntity(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('habitId: $habitId, ')
          ..write('count: $count, ')
          ..write('note: $note, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, habitId, count, note, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletionEntity &&
          other.id == this.id &&
          other.date == this.date &&
          other.habitId == this.habitId &&
          other.count == this.count &&
          other.note == this.note &&
          other.completedAt == this.completedAt);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletionEntity> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> habitId;
  final Value<int> count;
  final Value<String?> note;
  final Value<DateTime> completedAt;
  const HabitCompletionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.habitId = const Value.absent(),
    this.count = const Value.absent(),
    this.note = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  HabitCompletionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int habitId,
    this.count = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime completedAt,
  })  : date = Value(date),
        habitId = Value(habitId),
        completedAt = Value(completedAt);
  static Insertable<HabitCompletionEntity> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? habitId,
    Expression<int>? count,
    Expression<String>? note,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (habitId != null) 'habit_id': habitId,
      if (count != null) 'count': count,
      if (note != null) 'note': note,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  HabitCompletionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? habitId,
      Value<int>? count,
      Value<String?>? note,
      Value<DateTime>? completedAt}) {
    return HabitCompletionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      habitId: habitId ?? this.habitId,
      count: count ?? this.count,
      note: note ?? this.note,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('habitId: $habitId, ')
          ..write('count: $count, ')
          ..write('note: $note, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $DiariesTable extends Diaries with TableInfo<$DiariesTable, DiaryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
      'icon_code_point', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, color, iconCodePoint, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaries';
  @override
  VerificationContext validateIntegrity(Insertable<DiaryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['icon_code_point']!, _iconCodePointMeta));
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      iconCodePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_code_point'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $DiariesTable createAlias(String alias) {
    return $DiariesTable(attachedDatabase, alias);
  }
}

class DiaryEntity extends DataClass implements Insertable<DiaryEntity> {
  final int id;
  final String name;
  final String? description;
  final int color;
  final int iconCodePoint;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const DiaryEntity(
      {required this.id,
      required this.name,
      this.description,
      required this.color,
      required this.iconCodePoint,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color'] = Variable<int>(color);
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  DiariesCompanion toCompanion(bool nullToAbsent) {
    return DiariesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: Value(color),
      iconCodePoint: Value(iconCodePoint),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DiaryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<int>(json['color']),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<int>(color),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  DiaryEntity copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? color,
          int? iconCodePoint,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      DiaryEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        color: color ?? this.color,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  DiaryEntity copyWithCompanion(DiariesCompanion data) {
    return DiaryEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      color: data.color.present ? data.color.value : this.color,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, color, iconCodePoint, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.color == this.color &&
          other.iconCodePoint == this.iconCodePoint &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiariesCompanion extends UpdateCompanion<DiaryEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> color;
  final Value<int> iconCodePoint;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const DiariesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DiariesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int color,
    required int iconCodePoint,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        color = Value(color),
        iconCodePoint = Value(iconCodePoint),
        createdAt = Value(createdAt);
  static Insertable<DiaryEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? color,
    Expression<int>? iconCodePoint,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DiariesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? color,
      Value<int>? iconCodePoint,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return DiariesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiariesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _diaryIdMeta =
      const VerificationMeta('diaryId');
  @override
  late final GeneratedColumn<int> diaryId = GeneratedColumn<int>(
      'diary_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES diaries (id)'));
  static const VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
      'icon_code_point', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _iconColorMeta =
      const VerificationMeta('iconColor');
  @override
  late final GeneratedColumn<int> iconColor = GeneratedColumn<int>(
      'icon_color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
      'mood', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voiceNotePathMeta =
      const VerificationMeta('voiceNotePath');
  @override
  late final GeneratedColumn<String> voiceNotePath = GeneratedColumn<String>(
      'voice_note_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hasVoiceNoteMeta =
      const VerificationMeta('hasVoiceNote');
  @override
  late final GeneratedColumn<bool> hasVoiceNote = GeneratedColumn<bool>(
      'has_voice_note', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_voice_note" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _wordCountMeta =
      const VerificationMeta('wordCount');
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
      'word_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        date,
        diaryId,
        iconCodePoint,
        iconColor,
        mood,
        tags,
        voiceNotePath,
        hasVoiceNote,
        wordCount,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('diary_id')) {
      context.handle(_diaryIdMeta,
          diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta));
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['icon_code_point']!, _iconCodePointMeta));
    }
    if (data.containsKey('icon_color')) {
      context.handle(_iconColorMeta,
          iconColor.isAcceptableOrUnknown(data['icon_color']!, _iconColorMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('voice_note_path')) {
      context.handle(
          _voiceNotePathMeta,
          voiceNotePath.isAcceptableOrUnknown(
              data['voice_note_path']!, _voiceNotePathMeta));
    }
    if (data.containsKey('has_voice_note')) {
      context.handle(
          _hasVoiceNoteMeta,
          hasVoiceNote.isAcceptableOrUnknown(
              data['has_voice_note']!, _hasVoiceNoteMeta));
    }
    if (data.containsKey('word_count')) {
      context.handle(_wordCountMeta,
          wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      diaryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}diary_id']),
      iconCodePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_code_point']),
      iconColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_color']),
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      voiceNotePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voice_note_path']),
      hasVoiceNote: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_voice_note'])!,
      wordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntryEntity extends DataClass
    implements Insertable<JournalEntryEntity> {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  final int? diaryId;
  final int? iconCodePoint;
  final int? iconColor;
  final int mood;
  final String? tags;
  final String? voiceNotePath;
  final bool hasVoiceNote;
  final int wordCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntryEntity(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      this.diaryId,
      this.iconCodePoint,
      this.iconColor,
      required this.mood,
      this.tags,
      this.voiceNotePath,
      required this.hasVoiceNote,
      required this.wordCount,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || diaryId != null) {
      map['diary_id'] = Variable<int>(diaryId);
    }
    if (!nullToAbsent || iconCodePoint != null) {
      map['icon_code_point'] = Variable<int>(iconCodePoint);
    }
    if (!nullToAbsent || iconColor != null) {
      map['icon_color'] = Variable<int>(iconColor);
    }
    map['mood'] = Variable<int>(mood);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || voiceNotePath != null) {
      map['voice_note_path'] = Variable<String>(voiceNotePath);
    }
    map['has_voice_note'] = Variable<bool>(hasVoiceNote);
    map['word_count'] = Variable<int>(wordCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      date: Value(date),
      diaryId: diaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(diaryId),
      iconCodePoint: iconCodePoint == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCodePoint),
      iconColor: iconColor == null && nullToAbsent
          ? const Value.absent()
          : Value(iconColor),
      mood: Value(mood),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      voiceNotePath: voiceNotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceNotePath),
      hasVoiceNote: Value(hasVoiceNote),
      wordCount: Value(wordCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryEntity(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<DateTime>(json['date']),
      diaryId: serializer.fromJson<int?>(json['diaryId']),
      iconCodePoint: serializer.fromJson<int?>(json['iconCodePoint']),
      iconColor: serializer.fromJson<int?>(json['iconColor']),
      mood: serializer.fromJson<int>(json['mood']),
      tags: serializer.fromJson<String?>(json['tags']),
      voiceNotePath: serializer.fromJson<String?>(json['voiceNotePath']),
      hasVoiceNote: serializer.fromJson<bool>(json['hasVoiceNote']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<DateTime>(date),
      'diaryId': serializer.toJson<int?>(diaryId),
      'iconCodePoint': serializer.toJson<int?>(iconCodePoint),
      'iconColor': serializer.toJson<int?>(iconColor),
      'mood': serializer.toJson<int>(mood),
      'tags': serializer.toJson<String?>(tags),
      'voiceNotePath': serializer.toJson<String?>(voiceNotePath),
      'hasVoiceNote': serializer.toJson<bool>(hasVoiceNote),
      'wordCount': serializer.toJson<int>(wordCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntryEntity copyWith(
          {int? id,
          String? title,
          String? content,
          DateTime? date,
          Value<int?> diaryId = const Value.absent(),
          Value<int?> iconCodePoint = const Value.absent(),
          Value<int?> iconColor = const Value.absent(),
          int? mood,
          Value<String?> tags = const Value.absent(),
          Value<String?> voiceNotePath = const Value.absent(),
          bool? hasVoiceNote,
          int? wordCount,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      JournalEntryEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        date: date ?? this.date,
        diaryId: diaryId.present ? diaryId.value : this.diaryId,
        iconCodePoint:
            iconCodePoint.present ? iconCodePoint.value : this.iconCodePoint,
        iconColor: iconColor.present ? iconColor.value : this.iconColor,
        mood: mood ?? this.mood,
        tags: tags.present ? tags.value : this.tags,
        voiceNotePath:
            voiceNotePath.present ? voiceNotePath.value : this.voiceNotePath,
        hasVoiceNote: hasVoiceNote ?? this.hasVoiceNote,
        wordCount: wordCount ?? this.wordCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  JournalEntryEntity copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntryEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      date: data.date.present ? data.date.value : this.date,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      iconColor: data.iconColor.present ? data.iconColor.value : this.iconColor,
      mood: data.mood.present ? data.mood.value : this.mood,
      tags: data.tags.present ? data.tags.value : this.tags,
      voiceNotePath: data.voiceNotePath.present
          ? data.voiceNotePath.value
          : this.voiceNotePath,
      hasVoiceNote: data.hasVoiceNote.present
          ? data.hasVoiceNote.value
          : this.hasVoiceNote,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('diaryId: $diaryId, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('iconColor: $iconColor, ')
          ..write('mood: $mood, ')
          ..write('tags: $tags, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('hasVoiceNote: $hasVoiceNote, ')
          ..write('wordCount: $wordCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      content,
      date,
      diaryId,
      iconCodePoint,
      iconColor,
      mood,
      tags,
      voiceNotePath,
      hasVoiceNote,
      wordCount,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.date == this.date &&
          other.diaryId == this.diaryId &&
          other.iconCodePoint == this.iconCodePoint &&
          other.iconColor == this.iconColor &&
          other.mood == this.mood &&
          other.tags == this.tags &&
          other.voiceNotePath == this.voiceNotePath &&
          other.hasVoiceNote == this.hasVoiceNote &&
          other.wordCount == this.wordCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntryEntity> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> date;
  final Value<int?> diaryId;
  final Value<int?> iconCodePoint;
  final Value<int?> iconColor;
  final Value<int> mood;
  final Value<String?> tags;
  final Value<String?> voiceNotePath;
  final Value<bool> hasVoiceNote;
  final Value<int> wordCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.iconColor = const Value.absent(),
    this.mood = const Value.absent(),
    this.tags = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.hasVoiceNote = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    required DateTime date,
    this.diaryId = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.iconColor = const Value.absent(),
    this.mood = const Value.absent(),
    this.tags = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.hasVoiceNote = const Value.absent(),
    this.wordCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : title = Value(title),
        content = Value(content),
        date = Value(date),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<JournalEntryEntity> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? date,
    Expression<int>? diaryId,
    Expression<int>? iconCodePoint,
    Expression<int>? iconColor,
    Expression<int>? mood,
    Expression<String>? tags,
    Expression<String>? voiceNotePath,
    Expression<bool>? hasVoiceNote,
    Expression<int>? wordCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
      if (diaryId != null) 'diary_id': diaryId,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (iconColor != null) 'icon_color': iconColor,
      if (mood != null) 'mood': mood,
      if (tags != null) 'tags': tags,
      if (voiceNotePath != null) 'voice_note_path': voiceNotePath,
      if (hasVoiceNote != null) 'has_voice_note': hasVoiceNote,
      if (wordCount != null) 'word_count': wordCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime>? date,
      Value<int?>? diaryId,
      Value<int?>? iconCodePoint,
      Value<int?>? iconColor,
      Value<int>? mood,
      Value<String?>? tags,
      Value<String?>? voiceNotePath,
      Value<bool>? hasVoiceNote,
      Value<int>? wordCount,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      diaryId: diaryId ?? this.diaryId,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconColor: iconColor ?? this.iconColor,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      hasVoiceNote: hasVoiceNote ?? this.hasVoiceNote,
      wordCount: wordCount ?? this.wordCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<int>(diaryId.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (iconColor.present) {
      map['icon_color'] = Variable<int>(iconColor.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (voiceNotePath.present) {
      map['voice_note_path'] = Variable<String>(voiceNotePath.value);
    }
    if (hasVoiceNote.present) {
      map['has_voice_note'] = Variable<bool>(hasVoiceNote.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('diaryId: $diaryId, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('iconColor: $iconColor, ')
          ..write('mood: $mood, ')
          ..write('tags: $tags, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('hasVoiceNote: $hasVoiceNote, ')
          ..write('wordCount: $wordCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, AchievementEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetValueMeta =
      const VerificationMeta('targetValue');
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
      'target_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentValueMeta =
      const VerificationMeta('currentValue');
  @override
  late final GeneratedColumn<int> currentValue = GeneratedColumn<int>(
      'current_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _xpRewardMeta =
      const VerificationMeta('xpReward');
  @override
  late final GeneratedColumn<int> xpReward = GeneratedColumn<int>(
      'xp_reward', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isUnlockedMeta =
      const VerificationMeta('isUnlocked');
  @override
  late final GeneratedColumn<bool> isUnlocked = GeneratedColumn<bool>(
      'is_unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        key,
        name,
        description,
        icon,
        type,
        targetValue,
        currentValue,
        xpReward,
        isUnlocked,
        unlockedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(Insertable<AchievementEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
          _targetValueMeta,
          targetValue.isAcceptableOrUnknown(
              data['target_value']!, _targetValueMeta));
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
          _currentValueMeta,
          currentValue.isAcceptableOrUnknown(
              data['current_value']!, _currentValueMeta));
    }
    if (data.containsKey('xp_reward')) {
      context.handle(_xpRewardMeta,
          xpReward.isAcceptableOrUnknown(data['xp_reward']!, _xpRewardMeta));
    }
    if (data.containsKey('is_unlocked')) {
      context.handle(
          _isUnlockedMeta,
          isUnlocked.isAcceptableOrUnknown(
              data['is_unlocked']!, _isUnlockedMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AchievementEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      targetValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_value'])!,
      currentValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_value'])!,
      xpReward: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_reward'])!,
      isUnlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_unlocked'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at']),
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class AchievementEntity extends DataClass
    implements Insertable<AchievementEntity> {
  final int id;
  final String key;
  final String name;
  final String description;
  final String icon;
  final int type;
  final int targetValue;
  final int currentValue;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  const AchievementEntity(
      {required this.id,
      required this.key,
      required this.name,
      required this.description,
      required this.icon,
      required this.type,
      required this.targetValue,
      required this.currentValue,
      required this.xpReward,
      required this.isUnlocked,
      this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['type'] = Variable<int>(type);
    map['target_value'] = Variable<int>(targetValue);
    map['current_value'] = Variable<int>(currentValue);
    map['xp_reward'] = Variable<int>(xpReward);
    map['is_unlocked'] = Variable<bool>(isUnlocked);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      key: Value(key),
      name: Value(name),
      description: Value(description),
      icon: Value(icon),
      type: Value(type),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      xpReward: Value(xpReward),
      isUnlocked: Value(isUnlocked),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
    );
  }

  factory AchievementEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementEntity(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      type: serializer.fromJson<int>(json['type']),
      targetValue: serializer.fromJson<int>(json['targetValue']),
      currentValue: serializer.fromJson<int>(json['currentValue']),
      xpReward: serializer.fromJson<int>(json['xpReward']),
      isUnlocked: serializer.fromJson<bool>(json['isUnlocked']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'type': serializer.toJson<int>(type),
      'targetValue': serializer.toJson<int>(targetValue),
      'currentValue': serializer.toJson<int>(currentValue),
      'xpReward': serializer.toJson<int>(xpReward),
      'isUnlocked': serializer.toJson<bool>(isUnlocked),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
    };
  }

  AchievementEntity copyWith(
          {int? id,
          String? key,
          String? name,
          String? description,
          String? icon,
          int? type,
          int? targetValue,
          int? currentValue,
          int? xpReward,
          bool? isUnlocked,
          Value<DateTime?> unlockedAt = const Value.absent()}) =>
      AchievementEntity(
        id: id ?? this.id,
        key: key ?? this.key,
        name: name ?? this.name,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        type: type ?? this.type,
        targetValue: targetValue ?? this.targetValue,
        currentValue: currentValue ?? this.currentValue,
        xpReward: xpReward ?? this.xpReward,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
      );
  AchievementEntity copyWithCompanion(AchievementsCompanion data) {
    return AchievementEntity(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      type: data.type.present ? data.type.value : this.type,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      xpReward: data.xpReward.present ? data.xpReward.value : this.xpReward,
      isUnlocked:
          data.isUnlocked.present ? data.isUnlocked.value : this.isUnlocked,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementEntity(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('xpReward: $xpReward, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, name, description, icon, type,
      targetValue, currentValue, xpReward, isUnlocked, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementEntity &&
          other.id == this.id &&
          other.key == this.key &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.xpReward == this.xpReward &&
          other.isUnlocked == this.isUnlocked &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsCompanion extends UpdateCompanion<AchievementEntity> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> name;
  final Value<String> description;
  final Value<String> icon;
  final Value<int> type;
  final Value<int> targetValue;
  final Value<int> currentValue;
  final Value<int> xpReward;
  final Value<bool> isUnlocked;
  final Value<DateTime?> unlockedAt;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String name,
    required String description,
    required String icon,
    required int type,
    required int targetValue,
    this.currentValue = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
  })  : key = Value(key),
        name = Value(name),
        description = Value(description),
        icon = Value(icon),
        type = Value(type),
        targetValue = Value(targetValue);
  static Insertable<AchievementEntity> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? type,
    Expression<int>? targetValue,
    Expression<int>? currentValue,
    Expression<int>? xpReward,
    Expression<bool>? isUnlocked,
    Expression<DateTime>? unlockedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (xpReward != null) 'xp_reward': xpReward,
      if (isUnlocked != null) 'is_unlocked': isUnlocked,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
    });
  }

  AchievementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? name,
      Value<String>? description,
      Value<String>? icon,
      Value<int>? type,
      Value<int>? targetValue,
      Value<int>? currentValue,
      Value<int>? xpReward,
      Value<bool>? isUnlocked,
      Value<DateTime?>? unlockedAt}) {
    return AchievementsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<int>(currentValue.value);
    }
    if (xpReward.present) {
      map['xp_reward'] = Variable<int>(xpReward.value);
    }
    if (isUnlocked.present) {
      map['is_unlocked'] = Variable<bool>(isUnlocked.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('xpReward: $xpReward, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
      'xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _joinDateMeta =
      const VerificationMeta('joinDate');
  @override
  late final GeneratedColumn<DateTime> joinDate = GeneratedColumn<DateTime>(
      'join_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, email, xp, level, joinDate, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(Insertable<UserProgressEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('join_date')) {
      context.handle(_joinDateMeta,
          joinDate.isAcceptableOrUnknown(data['join_date']!, _joinDateMeta));
    } else if (isInserting) {
      context.missing(_joinDateMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      xp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      joinDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}join_date'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressEntity extends DataClass
    implements Insertable<UserProgressEntity> {
  final int id;
  final String? email;
  final int xp;
  final int level;
  final DateTime joinDate;
  final DateTime lastUpdated;
  const UserProgressEntity(
      {required this.id,
      this.email,
      required this.xp,
      required this.level,
      required this.joinDate,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['xp'] = Variable<int>(xp);
    map['level'] = Variable<int>(level);
    map['join_date'] = Variable<DateTime>(joinDate);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      xp: Value(xp),
      level: Value(level),
      joinDate: Value(joinDate),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory UserProgressEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressEntity(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String?>(json['email']),
      xp: serializer.fromJson<int>(json['xp']),
      level: serializer.fromJson<int>(json['level']),
      joinDate: serializer.fromJson<DateTime>(json['joinDate']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String?>(email),
      'xp': serializer.toJson<int>(xp),
      'level': serializer.toJson<int>(level),
      'joinDate': serializer.toJson<DateTime>(joinDate),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  UserProgressEntity copyWith(
          {int? id,
          Value<String?> email = const Value.absent(),
          int? xp,
          int? level,
          DateTime? joinDate,
          DateTime? lastUpdated}) =>
      UserProgressEntity(
        id: id ?? this.id,
        email: email.present ? email.value : this.email,
        xp: xp ?? this.xp,
        level: level ?? this.level,
        joinDate: joinDate ?? this.joinDate,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  UserProgressEntity copyWithCompanion(UserProgressCompanion data) {
    return UserProgressEntity(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      xp: data.xp.present ? data.xp.value : this.xp,
      level: data.level.present ? data.level.value : this.level,
      joinDate: data.joinDate.present ? data.joinDate.value : this.joinDate,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressEntity(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('joinDate: $joinDate, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, xp, level, joinDate, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressEntity &&
          other.id == this.id &&
          other.email == this.email &&
          other.xp == this.xp &&
          other.level == this.level &&
          other.joinDate == this.joinDate &&
          other.lastUpdated == this.lastUpdated);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressEntity> {
  final Value<int> id;
  final Value<String?> email;
  final Value<int> xp;
  final Value<int> level;
  final Value<DateTime> joinDate;
  final Value<DateTime> lastUpdated;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    required DateTime joinDate,
    required DateTime lastUpdated,
  })  : joinDate = Value(joinDate),
        lastUpdated = Value(lastUpdated);
  static Insertable<UserProgressEntity> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<int>? xp,
    Expression<int>? level,
    Expression<DateTime>? joinDate,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (xp != null) 'xp': xp,
      if (level != null) 'level': level,
      if (joinDate != null) 'join_date': joinDate,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  UserProgressCompanion copyWith(
      {Value<int>? id,
      Value<String?>? email,
      Value<int>? xp,
      Value<int>? level,
      Value<DateTime>? joinDate,
      Value<DateTime>? lastUpdated}) {
    return UserProgressCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      joinDate: joinDate ?? this.joinDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (joinDate.present) {
      map['join_date'] = Variable<DateTime>(joinDate.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('joinDate: $joinDate, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $FocusSettingsTable extends FocusSettings
    with TableInfo<$FocusSettingsTable, FocusSettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _focusDurationMeta =
      const VerificationMeta('focusDuration');
  @override
  late final GeneratedColumn<int> focusDuration = GeneratedColumn<int>(
      'focus_duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(25));
  static const VerificationMeta _shortBreakDurationMeta =
      const VerificationMeta('shortBreakDuration');
  @override
  late final GeneratedColumn<int> shortBreakDuration = GeneratedColumn<int>(
      'short_break_duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _longBreakDurationMeta =
      const VerificationMeta('longBreakDuration');
  @override
  late final GeneratedColumn<int> longBreakDuration = GeneratedColumn<int>(
      'long_break_duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(15));
  static const VerificationMeta _longBreakIntervalMeta =
      const VerificationMeta('longBreakInterval');
  @override
  late final GeneratedColumn<int> longBreakInterval = GeneratedColumn<int>(
      'long_break_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _autoStartBreaksMeta =
      const VerificationMeta('autoStartBreaks');
  @override
  late final GeneratedColumn<bool> autoStartBreaks = GeneratedColumn<bool>(
      'auto_start_breaks', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_start_breaks" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _autoStartPomodorosMeta =
      const VerificationMeta('autoStartPomodoros');
  @override
  late final GeneratedColumn<bool> autoStartPomodoros = GeneratedColumn<bool>(
      'auto_start_pomodoros', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_start_pomodoros" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        focusDuration,
        shortBreakDuration,
        longBreakDuration,
        longBreakInterval,
        autoStartBreaks,
        autoStartPomodoros
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_settings';
  @override
  VerificationContext validateIntegrity(Insertable<FocusSettingsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('focus_duration')) {
      context.handle(
          _focusDurationMeta,
          focusDuration.isAcceptableOrUnknown(
              data['focus_duration']!, _focusDurationMeta));
    }
    if (data.containsKey('short_break_duration')) {
      context.handle(
          _shortBreakDurationMeta,
          shortBreakDuration.isAcceptableOrUnknown(
              data['short_break_duration']!, _shortBreakDurationMeta));
    }
    if (data.containsKey('long_break_duration')) {
      context.handle(
          _longBreakDurationMeta,
          longBreakDuration.isAcceptableOrUnknown(
              data['long_break_duration']!, _longBreakDurationMeta));
    }
    if (data.containsKey('long_break_interval')) {
      context.handle(
          _longBreakIntervalMeta,
          longBreakInterval.isAcceptableOrUnknown(
              data['long_break_interval']!, _longBreakIntervalMeta));
    }
    if (data.containsKey('auto_start_breaks')) {
      context.handle(
          _autoStartBreaksMeta,
          autoStartBreaks.isAcceptableOrUnknown(
              data['auto_start_breaks']!, _autoStartBreaksMeta));
    }
    if (data.containsKey('auto_start_pomodoros')) {
      context.handle(
          _autoStartPomodorosMeta,
          autoStartPomodoros.isAcceptableOrUnknown(
              data['auto_start_pomodoros']!, _autoStartPomodorosMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSettingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      focusDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}focus_duration'])!,
      shortBreakDuration: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}short_break_duration'])!,
      longBreakDuration: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}long_break_duration'])!,
      longBreakInterval: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}long_break_interval'])!,
      autoStartBreaks: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}auto_start_breaks'])!,
      autoStartPomodoros: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}auto_start_pomodoros'])!,
    );
  }

  @override
  $FocusSettingsTable createAlias(String alias) {
    return $FocusSettingsTable(attachedDatabase, alias);
  }
}

class FocusSettingsData extends DataClass
    implements Insertable<FocusSettingsData> {
  /// Single row ID (we only need one row of settings)
  final int id;

  /// Focus duration in minutes (default: 25)
  final int focusDuration;

  /// Short break duration in minutes (default: 5)
  final int shortBreakDuration;

  /// Long break duration in minutes (default: 15)
  final int longBreakDuration;

  /// Number of pomodoros before a long break (default: 4)
  final int longBreakInterval;

  /// Auto-start breaks? (default: false)
  final bool autoStartBreaks;

  /// Auto-start pomodoros? (default: false)
  final bool autoStartPomodoros;
  const FocusSettingsData(
      {required this.id,
      required this.focusDuration,
      required this.shortBreakDuration,
      required this.longBreakDuration,
      required this.longBreakInterval,
      required this.autoStartBreaks,
      required this.autoStartPomodoros});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['focus_duration'] = Variable<int>(focusDuration);
    map['short_break_duration'] = Variable<int>(shortBreakDuration);
    map['long_break_duration'] = Variable<int>(longBreakDuration);
    map['long_break_interval'] = Variable<int>(longBreakInterval);
    map['auto_start_breaks'] = Variable<bool>(autoStartBreaks);
    map['auto_start_pomodoros'] = Variable<bool>(autoStartPomodoros);
    return map;
  }

  FocusSettingsCompanion toCompanion(bool nullToAbsent) {
    return FocusSettingsCompanion(
      id: Value(id),
      focusDuration: Value(focusDuration),
      shortBreakDuration: Value(shortBreakDuration),
      longBreakDuration: Value(longBreakDuration),
      longBreakInterval: Value(longBreakInterval),
      autoStartBreaks: Value(autoStartBreaks),
      autoStartPomodoros: Value(autoStartPomodoros),
    );
  }

  factory FocusSettingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSettingsData(
      id: serializer.fromJson<int>(json['id']),
      focusDuration: serializer.fromJson<int>(json['focusDuration']),
      shortBreakDuration: serializer.fromJson<int>(json['shortBreakDuration']),
      longBreakDuration: serializer.fromJson<int>(json['longBreakDuration']),
      longBreakInterval: serializer.fromJson<int>(json['longBreakInterval']),
      autoStartBreaks: serializer.fromJson<bool>(json['autoStartBreaks']),
      autoStartPomodoros: serializer.fromJson<bool>(json['autoStartPomodoros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'focusDuration': serializer.toJson<int>(focusDuration),
      'shortBreakDuration': serializer.toJson<int>(shortBreakDuration),
      'longBreakDuration': serializer.toJson<int>(longBreakDuration),
      'longBreakInterval': serializer.toJson<int>(longBreakInterval),
      'autoStartBreaks': serializer.toJson<bool>(autoStartBreaks),
      'autoStartPomodoros': serializer.toJson<bool>(autoStartPomodoros),
    };
  }

  FocusSettingsData copyWith(
          {int? id,
          int? focusDuration,
          int? shortBreakDuration,
          int? longBreakDuration,
          int? longBreakInterval,
          bool? autoStartBreaks,
          bool? autoStartPomodoros}) =>
      FocusSettingsData(
        id: id ?? this.id,
        focusDuration: focusDuration ?? this.focusDuration,
        shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
        longBreakDuration: longBreakDuration ?? this.longBreakDuration,
        longBreakInterval: longBreakInterval ?? this.longBreakInterval,
        autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
        autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
      );
  FocusSettingsData copyWithCompanion(FocusSettingsCompanion data) {
    return FocusSettingsData(
      id: data.id.present ? data.id.value : this.id,
      focusDuration: data.focusDuration.present
          ? data.focusDuration.value
          : this.focusDuration,
      shortBreakDuration: data.shortBreakDuration.present
          ? data.shortBreakDuration.value
          : this.shortBreakDuration,
      longBreakDuration: data.longBreakDuration.present
          ? data.longBreakDuration.value
          : this.longBreakDuration,
      longBreakInterval: data.longBreakInterval.present
          ? data.longBreakInterval.value
          : this.longBreakInterval,
      autoStartBreaks: data.autoStartBreaks.present
          ? data.autoStartBreaks.value
          : this.autoStartBreaks,
      autoStartPomodoros: data.autoStartPomodoros.present
          ? data.autoStartPomodoros.value
          : this.autoStartPomodoros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSettingsData(')
          ..write('id: $id, ')
          ..write('focusDuration: $focusDuration, ')
          ..write('shortBreakDuration: $shortBreakDuration, ')
          ..write('longBreakDuration: $longBreakDuration, ')
          ..write('longBreakInterval: $longBreakInterval, ')
          ..write('autoStartBreaks: $autoStartBreaks, ')
          ..write('autoStartPomodoros: $autoStartPomodoros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      focusDuration,
      shortBreakDuration,
      longBreakDuration,
      longBreakInterval,
      autoStartBreaks,
      autoStartPomodoros);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSettingsData &&
          other.id == this.id &&
          other.focusDuration == this.focusDuration &&
          other.shortBreakDuration == this.shortBreakDuration &&
          other.longBreakDuration == this.longBreakDuration &&
          other.longBreakInterval == this.longBreakInterval &&
          other.autoStartBreaks == this.autoStartBreaks &&
          other.autoStartPomodoros == this.autoStartPomodoros);
}

class FocusSettingsCompanion extends UpdateCompanion<FocusSettingsData> {
  final Value<int> id;
  final Value<int> focusDuration;
  final Value<int> shortBreakDuration;
  final Value<int> longBreakDuration;
  final Value<int> longBreakInterval;
  final Value<bool> autoStartBreaks;
  final Value<bool> autoStartPomodoros;
  const FocusSettingsCompanion({
    this.id = const Value.absent(),
    this.focusDuration = const Value.absent(),
    this.shortBreakDuration = const Value.absent(),
    this.longBreakDuration = const Value.absent(),
    this.longBreakInterval = const Value.absent(),
    this.autoStartBreaks = const Value.absent(),
    this.autoStartPomodoros = const Value.absent(),
  });
  FocusSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.focusDuration = const Value.absent(),
    this.shortBreakDuration = const Value.absent(),
    this.longBreakDuration = const Value.absent(),
    this.longBreakInterval = const Value.absent(),
    this.autoStartBreaks = const Value.absent(),
    this.autoStartPomodoros = const Value.absent(),
  });
  static Insertable<FocusSettingsData> custom({
    Expression<int>? id,
    Expression<int>? focusDuration,
    Expression<int>? shortBreakDuration,
    Expression<int>? longBreakDuration,
    Expression<int>? longBreakInterval,
    Expression<bool>? autoStartBreaks,
    Expression<bool>? autoStartPomodoros,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (focusDuration != null) 'focus_duration': focusDuration,
      if (shortBreakDuration != null)
        'short_break_duration': shortBreakDuration,
      if (longBreakDuration != null) 'long_break_duration': longBreakDuration,
      if (longBreakInterval != null) 'long_break_interval': longBreakInterval,
      if (autoStartBreaks != null) 'auto_start_breaks': autoStartBreaks,
      if (autoStartPomodoros != null)
        'auto_start_pomodoros': autoStartPomodoros,
    });
  }

  FocusSettingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? focusDuration,
      Value<int>? shortBreakDuration,
      Value<int>? longBreakDuration,
      Value<int>? longBreakInterval,
      Value<bool>? autoStartBreaks,
      Value<bool>? autoStartPomodoros}) {
    return FocusSettingsCompanion(
      id: id ?? this.id,
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (focusDuration.present) {
      map['focus_duration'] = Variable<int>(focusDuration.value);
    }
    if (shortBreakDuration.present) {
      map['short_break_duration'] = Variable<int>(shortBreakDuration.value);
    }
    if (longBreakDuration.present) {
      map['long_break_duration'] = Variable<int>(longBreakDuration.value);
    }
    if (longBreakInterval.present) {
      map['long_break_interval'] = Variable<int>(longBreakInterval.value);
    }
    if (autoStartBreaks.present) {
      map['auto_start_breaks'] = Variable<bool>(autoStartBreaks.value);
    }
    if (autoStartPomodoros.present) {
      map['auto_start_pomodoros'] = Variable<bool>(autoStartPomodoros.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSettingsCompanion(')
          ..write('id: $id, ')
          ..write('focusDuration: $focusDuration, ')
          ..write('shortBreakDuration: $shortBreakDuration, ')
          ..write('longBreakDuration: $longBreakDuration, ')
          ..write('longBreakInterval: $longBreakInterval, ')
          ..write('autoStartBreaks: $autoStartBreaks, ')
          ..write('autoStartPomodoros: $autoStartPomodoros')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitCompletionsTable habitCompletions =
      $HabitCompletionsTable(this);
  late final $DiariesTable diaries = $DiariesTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $FocusSettingsTable focusSettings = $FocusSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        habits,
        habitCompletions,
        diaries,
        journalEntries,
        achievements,
        userProgress,
        focusSettings
      ];
}

typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  required String name,
  required String emoji,
  required int category,
  Value<int> priority,
  required int frequency,
  Value<String?> customDays,
  Value<String?> description,
  required String colorHex,
  Value<int> targetCount,
  Value<String?> reminderTime,
  Value<bool> reminderEnabled,
  Value<int> sortOrder,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> emoji,
  Value<int> category,
  Value<int> priority,
  Value<int> frequency,
  Value<String?> customDays,
  Value<String?> description,
  Value<String> colorHex,
  Value<int> targetCount,
  Value<String?> reminderTime,
  Value<bool> reminderEnabled,
  Value<int> sortOrder,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitEntity> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitCompletionsTable,
      List<HabitCompletionEntity>> _habitCompletionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.habitCompletions,
          aliasName:
              $_aliasNameGenerator(db.habits.id, db.habitCompletions.habitId));

  $$HabitCompletionsTableProcessedTableManager get habitCompletionsRefs {
    final manager =
        $$HabitCompletionsTableTableManager($_db, $_db.habitCompletions)
            .filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_habitCompletionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customDays => $composableBuilder(
      column: $table.customDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetCount => $composableBuilder(
      column: $table.targetCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> habitCompletionsRefs(
      Expression<bool> Function($$HabitCompletionsTableFilterComposer f) f) {
    final $$HabitCompletionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitCompletions,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitCompletionsTableFilterComposer(
              $db: $db,
              $table: $db.habitCompletions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customDays => $composableBuilder(
      column: $table.customDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetCount => $composableBuilder(
      column: $table.targetCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get customDays => $composableBuilder(
      column: $table.customDays, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get targetCount => $composableBuilder(
      column: $table.targetCount, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
      column: $table.reminderEnabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> habitCompletionsRefs<T extends Object>(
      Expression<T> Function($$HabitCompletionsTableAnnotationComposer a) f) {
    final $$HabitCompletionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitCompletions,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitCompletionsTableAnnotationComposer(
              $db: $db,
              $table: $db.habitCompletions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitsTable,
    HabitEntity,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (HabitEntity, $$HabitsTableReferences),
    HabitEntity,
    PrefetchHooks Function({bool habitCompletionsRefs})> {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> frequency = const Value.absent(),
            Value<String?> customDays = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<int> targetCount = const Value.absent(),
            Value<String?> reminderTime = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HabitsCompanion(
            id: id,
            name: name,
            emoji: emoji,
            category: category,
            priority: priority,
            frequency: frequency,
            customDays: customDays,
            description: description,
            colorHex: colorHex,
            targetCount: targetCount,
            reminderTime: reminderTime,
            reminderEnabled: reminderEnabled,
            sortOrder: sortOrder,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String emoji,
            required int category,
            Value<int> priority = const Value.absent(),
            required int frequency,
            Value<String?> customDays = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required String colorHex,
            Value<int> targetCount = const Value.absent(),
            Value<String?> reminderTime = const Value.absent(),
            Value<bool> reminderEnabled = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              HabitsCompanion.insert(
            id: id,
            name: name,
            emoji: emoji,
            category: category,
            priority: priority,
            frequency: frequency,
            customDays: customDays,
            description: description,
            colorHex: colorHex,
            targetCount: targetCount,
            reminderTime: reminderTime,
            reminderEnabled: reminderEnabled,
            sortOrder: sortOrder,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$HabitsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({habitCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitCompletionsRefs) db.habitCompletions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitCompletionsRefs)
                    await $_getPrefetchedData<HabitEntity, $HabitsTable, HabitCompletionEntity>(
                        currentTable: table,
                        referencedTable: $$HabitsTableReferences
                            ._habitCompletionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HabitsTableReferences(db, table, p0)
                                .habitCompletionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.habitId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitsTable,
    HabitEntity,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (HabitEntity, $$HabitsTableReferences),
    HabitEntity,
    PrefetchHooks Function({bool habitCompletionsRefs})>;
typedef $$HabitCompletionsTableCreateCompanionBuilder
    = HabitCompletionsCompanion Function({
  Value<int> id,
  required DateTime date,
  required int habitId,
  Value<int> count,
  Value<String?> note,
  required DateTime completedAt,
});
typedef $$HabitCompletionsTableUpdateCompanionBuilder
    = HabitCompletionsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> habitId,
  Value<int> count,
  Value<String?> note,
  Value<DateTime> completedAt,
});

final class $$HabitCompletionsTableReferences extends BaseReferences<
    _$AppDatabase, $HabitCompletionsTable, HabitCompletionEntity> {
  $$HabitCompletionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) => db.habits.createAlias(
      $_aliasNameGenerator(db.habitCompletions.habitId, db.habits.id));

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager($_db, $_db.habits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HabitCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableFilterComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableOrderingComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitCompletionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitCompletionsTable,
    HabitCompletionEntity,
    $$HabitCompletionsTableFilterComposer,
    $$HabitCompletionsTableOrderingComposer,
    $$HabitCompletionsTableAnnotationComposer,
    $$HabitCompletionsTableCreateCompanionBuilder,
    $$HabitCompletionsTableUpdateCompanionBuilder,
    (HabitCompletionEntity, $$HabitCompletionsTableReferences),
    HabitCompletionEntity,
    PrefetchHooks Function({bool habitId})> {
  $$HabitCompletionsTableTableManager(
      _$AppDatabase db, $HabitCompletionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> habitId = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
          }) =>
              HabitCompletionsCompanion(
            id: id,
            date: date,
            habitId: habitId,
            count: count,
            note: note,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int habitId,
            Value<int> count = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime completedAt,
          }) =>
              HabitCompletionsCompanion.insert(
            id: id,
            date: date,
            habitId: habitId,
            count: count,
            note: note,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HabitCompletionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (habitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$HabitCompletionsTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$HabitCompletionsTableReferences._habitIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HabitCompletionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitCompletionsTable,
    HabitCompletionEntity,
    $$HabitCompletionsTableFilterComposer,
    $$HabitCompletionsTableOrderingComposer,
    $$HabitCompletionsTableAnnotationComposer,
    $$HabitCompletionsTableCreateCompanionBuilder,
    $$HabitCompletionsTableUpdateCompanionBuilder,
    (HabitCompletionEntity, $$HabitCompletionsTableReferences),
    HabitCompletionEntity,
    PrefetchHooks Function({bool habitId})>;
typedef $$DiariesTableCreateCompanionBuilder = DiariesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required int color,
  required int iconCodePoint,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$DiariesTableUpdateCompanionBuilder = DiariesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int> color,
  Value<int> iconCodePoint,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

final class $$DiariesTableReferences
    extends BaseReferences<_$AppDatabase, $DiariesTable, DiaryEntity> {
  $$DiariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JournalEntriesTable, List<JournalEntryEntity>>
      _journalEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.journalEntries,
              aliasName: $_aliasNameGenerator(
                  db.diaries.id, db.journalEntries.diaryId));

  $$JournalEntriesTableProcessedTableManager get journalEntriesRefs {
    final manager = $$JournalEntriesTableTableManager($_db, $_db.journalEntries)
        .filter((f) => f.diaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DiariesTableFilterComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> journalEntriesRefs(
      Expression<bool> Function($$JournalEntriesTableFilterComposer f) f) {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.diaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableFilterComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> journalEntriesRefs<T extends Object>(
      Expression<T> Function($$JournalEntriesTableAnnotationComposer a) f) {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.diaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiariesTable,
    DiaryEntity,
    $$DiariesTableFilterComposer,
    $$DiariesTableOrderingComposer,
    $$DiariesTableAnnotationComposer,
    $$DiariesTableCreateCompanionBuilder,
    $$DiariesTableUpdateCompanionBuilder,
    (DiaryEntity, $$DiariesTableReferences),
    DiaryEntity,
    PrefetchHooks Function({bool journalEntriesRefs})> {
  $$DiariesTableTableManager(_$AppDatabase db, $DiariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<int> iconCodePoint = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              DiariesCompanion(
            id: id,
            name: name,
            description: description,
            color: color,
            iconCodePoint: iconCodePoint,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required int color,
            required int iconCodePoint,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              DiariesCompanion.insert(
            id: id,
            name: name,
            description: description,
            color: color,
            iconCodePoint: iconCodePoint,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DiariesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({journalEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntriesRefs) db.journalEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalEntriesRefs)
                    await $_getPrefetchedData<DiaryEntity, $DiariesTable,
                            JournalEntryEntity>(
                        currentTable: table,
                        referencedTable: $$DiariesTableReferences
                            ._journalEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DiariesTableReferences(db, table, p0)
                                .journalEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.diaryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DiariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiariesTable,
    DiaryEntity,
    $$DiariesTableFilterComposer,
    $$DiariesTableOrderingComposer,
    $$DiariesTableAnnotationComposer,
    $$DiariesTableCreateCompanionBuilder,
    $$DiariesTableUpdateCompanionBuilder,
    (DiaryEntity, $$DiariesTableReferences),
    DiaryEntity,
    PrefetchHooks Function({bool journalEntriesRefs})>;
typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  required String title,
  required String content,
  required DateTime date,
  Value<int?> diaryId,
  Value<int?> iconCodePoint,
  Value<int?> iconColor,
  Value<int> mood,
  Value<String?> tags,
  Value<String?> voiceNotePath,
  Value<bool> hasVoiceNote,
  Value<int> wordCount,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> content,
  Value<DateTime> date,
  Value<int?> diaryId,
  Value<int?> iconCodePoint,
  Value<int?> iconColor,
  Value<int> mood,
  Value<String?> tags,
  Value<String?> voiceNotePath,
  Value<bool> hasVoiceNote,
  Value<int> wordCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$JournalEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $JournalEntriesTable, JournalEntryEntity> {
  $$JournalEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DiariesTable _diaryIdTable(_$AppDatabase db) =>
      db.diaries.createAlias(
          $_aliasNameGenerator(db.journalEntries.diaryId, db.diaries.id));

  $$DiariesTableProcessedTableManager? get diaryId {
    final $_column = $_itemColumn<int>('diary_id');
    if ($_column == null) return null;
    final manager = $$DiariesTableTableManager($_db, $_db.diaries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconColor => $composableBuilder(
      column: $table.iconColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voiceNotePath => $composableBuilder(
      column: $table.voiceNotePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasVoiceNote => $composableBuilder(
      column: $table.hasVoiceNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordCount => $composableBuilder(
      column: $table.wordCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DiariesTableFilterComposer get diaryId {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableFilterComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconColor => $composableBuilder(
      column: $table.iconColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voiceNotePath => $composableBuilder(
      column: $table.voiceNotePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasVoiceNote => $composableBuilder(
      column: $table.hasVoiceNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordCount => $composableBuilder(
      column: $table.wordCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DiariesTableOrderingComposer get diaryId {
    final $$DiariesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableOrderingComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => column);

  GeneratedColumn<int> get iconColor =>
      $composableBuilder(column: $table.iconColor, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get voiceNotePath => $composableBuilder(
      column: $table.voiceNotePath, builder: (column) => column);

  GeneratedColumn<bool> get hasVoiceNote => $composableBuilder(
      column: $table.hasVoiceNote, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DiariesTableAnnotationComposer get diaryId {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableAnnotationComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntryEntity,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (JournalEntryEntity, $$JournalEntriesTableReferences),
    JournalEntryEntity,
    PrefetchHooks Function({bool diaryId})> {
  $$JournalEntriesTableTableManager(
      _$AppDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> diaryId = const Value.absent(),
            Value<int?> iconCodePoint = const Value.absent(),
            Value<int?> iconColor = const Value.absent(),
            Value<int> mood = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<String?> voiceNotePath = const Value.absent(),
            Value<bool> hasVoiceNote = const Value.absent(),
            Value<int> wordCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            title: title,
            content: content,
            date: date,
            diaryId: diaryId,
            iconCodePoint: iconCodePoint,
            iconColor: iconColor,
            mood: mood,
            tags: tags,
            voiceNotePath: voiceNotePath,
            hasVoiceNote: hasVoiceNote,
            wordCount: wordCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String content,
            required DateTime date,
            Value<int?> diaryId = const Value.absent(),
            Value<int?> iconCodePoint = const Value.absent(),
            Value<int?> iconColor = const Value.absent(),
            Value<int> mood = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<String?> voiceNotePath = const Value.absent(),
            Value<bool> hasVoiceNote = const Value.absent(),
            Value<int> wordCount = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            title: title,
            content: content,
            date: date,
            diaryId: diaryId,
            iconCodePoint: iconCodePoint,
            iconColor: iconColor,
            mood: mood,
            tags: tags,
            voiceNotePath: voiceNotePath,
            hasVoiceNote: hasVoiceNote,
            wordCount: wordCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JournalEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({diaryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (diaryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.diaryId,
                    referencedTable:
                        $$JournalEntriesTableReferences._diaryIdTable(db),
                    referencedColumn:
                        $$JournalEntriesTableReferences._diaryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntryEntity,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (JournalEntryEntity, $$JournalEntriesTableReferences),
    JournalEntryEntity,
    PrefetchHooks Function({bool diaryId})>;
typedef $$AchievementsTableCreateCompanionBuilder = AchievementsCompanion
    Function({
  Value<int> id,
  required String key,
  required String name,
  required String description,
  required String icon,
  required int type,
  required int targetValue,
  Value<int> currentValue,
  Value<int> xpReward,
  Value<bool> isUnlocked,
  Value<DateTime?> unlockedAt,
});
typedef $$AchievementsTableUpdateCompanionBuilder = AchievementsCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> name,
  Value<String> description,
  Value<String> icon,
  Value<int> type,
  Value<int> targetValue,
  Value<int> currentValue,
  Value<int> xpReward,
  Value<bool> isUnlocked,
  Value<DateTime?> unlockedAt,
});

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpReward => $composableBuilder(
      column: $table.xpReward, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentValue => $composableBuilder(
      column: $table.currentValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpReward => $composableBuilder(
      column: $table.xpReward, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => column);

  GeneratedColumn<int> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => column);

  GeneratedColumn<int> get xpReward =>
      $composableBuilder(column: $table.xpReward, builder: (column) => column);

  GeneratedColumn<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$AchievementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTable,
    AchievementEntity,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      AchievementEntity,
      BaseReferences<_$AppDatabase, $AchievementsTable, AchievementEntity>
    ),
    AchievementEntity,
    PrefetchHooks Function()> {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<int> targetValue = const Value.absent(),
            Value<int> currentValue = const Value.absent(),
            Value<int> xpReward = const Value.absent(),
            Value<bool> isUnlocked = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
          }) =>
              AchievementsCompanion(
            id: id,
            key: key,
            name: name,
            description: description,
            icon: icon,
            type: type,
            targetValue: targetValue,
            currentValue: currentValue,
            xpReward: xpReward,
            isUnlocked: isUnlocked,
            unlockedAt: unlockedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String name,
            required String description,
            required String icon,
            required int type,
            required int targetValue,
            Value<int> currentValue = const Value.absent(),
            Value<int> xpReward = const Value.absent(),
            Value<bool> isUnlocked = const Value.absent(),
            Value<DateTime?> unlockedAt = const Value.absent(),
          }) =>
              AchievementsCompanion.insert(
            id: id,
            key: key,
            name: name,
            description: description,
            icon: icon,
            type: type,
            targetValue: targetValue,
            currentValue: currentValue,
            xpReward: xpReward,
            isUnlocked: isUnlocked,
            unlockedAt: unlockedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTable,
    AchievementEntity,
    $$AchievementsTableFilterComposer,
    $$AchievementsTableOrderingComposer,
    $$AchievementsTableAnnotationComposer,
    $$AchievementsTableCreateCompanionBuilder,
    $$AchievementsTableUpdateCompanionBuilder,
    (
      AchievementEntity,
      BaseReferences<_$AppDatabase, $AchievementsTable, AchievementEntity>
    ),
    AchievementEntity,
    PrefetchHooks Function()>;
typedef $$UserProgressTableCreateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<String?> email,
  Value<int> xp,
  Value<int> level,
  required DateTime joinDate,
  required DateTime lastUpdated,
});
typedef $$UserProgressTableUpdateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<String?> email,
  Value<int> xp,
  Value<int> level,
  Value<DateTime> joinDate,
  Value<DateTime> lastUpdated,
});

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinDate => $composableBuilder(
      column: $table.joinDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinDate => $composableBuilder(
      column: $table.joinDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get joinDate =>
      $composableBuilder(column: $table.joinDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
}

class $$UserProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressEntity,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressEntity,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressEntity>
    ),
    UserProgressEntity,
    PrefetchHooks Function()> {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<DateTime> joinDate = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
          }) =>
              UserProgressCompanion(
            id: id,
            email: email,
            xp: xp,
            level: level,
            joinDate: joinDate,
            lastUpdated: lastUpdated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> level = const Value.absent(),
            required DateTime joinDate,
            required DateTime lastUpdated,
          }) =>
              UserProgressCompanion.insert(
            id: id,
            email: email,
            xp: xp,
            level: level,
            joinDate: joinDate,
            lastUpdated: lastUpdated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressEntity,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressEntity,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressEntity>
    ),
    UserProgressEntity,
    PrefetchHooks Function()>;
typedef $$FocusSettingsTableCreateCompanionBuilder = FocusSettingsCompanion
    Function({
  Value<int> id,
  Value<int> focusDuration,
  Value<int> shortBreakDuration,
  Value<int> longBreakDuration,
  Value<int> longBreakInterval,
  Value<bool> autoStartBreaks,
  Value<bool> autoStartPomodoros,
});
typedef $$FocusSettingsTableUpdateCompanionBuilder = FocusSettingsCompanion
    Function({
  Value<int> id,
  Value<int> focusDuration,
  Value<int> shortBreakDuration,
  Value<int> longBreakDuration,
  Value<int> longBreakInterval,
  Value<bool> autoStartBreaks,
  Value<bool> autoStartPomodoros,
});

class $$FocusSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSettingsTable> {
  $$FocusSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get focusDuration => $composableBuilder(
      column: $table.focusDuration, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shortBreakDuration => $composableBuilder(
      column: $table.shortBreakDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longBreakDuration => $composableBuilder(
      column: $table.longBreakDuration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longBreakInterval => $composableBuilder(
      column: $table.longBreakInterval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoStartBreaks => $composableBuilder(
      column: $table.autoStartBreaks,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoStartPomodoros => $composableBuilder(
      column: $table.autoStartPomodoros,
      builder: (column) => ColumnFilters(column));
}

class $$FocusSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSettingsTable> {
  $$FocusSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get focusDuration => $composableBuilder(
      column: $table.focusDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shortBreakDuration => $composableBuilder(
      column: $table.shortBreakDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longBreakDuration => $composableBuilder(
      column: $table.longBreakDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longBreakInterval => $composableBuilder(
      column: $table.longBreakInterval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoStartBreaks => $composableBuilder(
      column: $table.autoStartBreaks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoStartPomodoros => $composableBuilder(
      column: $table.autoStartPomodoros,
      builder: (column) => ColumnOrderings(column));
}

class $$FocusSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSettingsTable> {
  $$FocusSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get focusDuration => $composableBuilder(
      column: $table.focusDuration, builder: (column) => column);

  GeneratedColumn<int> get shortBreakDuration => $composableBuilder(
      column: $table.shortBreakDuration, builder: (column) => column);

  GeneratedColumn<int> get longBreakDuration => $composableBuilder(
      column: $table.longBreakDuration, builder: (column) => column);

  GeneratedColumn<int> get longBreakInterval => $composableBuilder(
      column: $table.longBreakInterval, builder: (column) => column);

  GeneratedColumn<bool> get autoStartBreaks => $composableBuilder(
      column: $table.autoStartBreaks, builder: (column) => column);

  GeneratedColumn<bool> get autoStartPomodoros => $composableBuilder(
      column: $table.autoStartPomodoros, builder: (column) => column);
}

class $$FocusSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FocusSettingsTable,
    FocusSettingsData,
    $$FocusSettingsTableFilterComposer,
    $$FocusSettingsTableOrderingComposer,
    $$FocusSettingsTableAnnotationComposer,
    $$FocusSettingsTableCreateCompanionBuilder,
    $$FocusSettingsTableUpdateCompanionBuilder,
    (
      FocusSettingsData,
      BaseReferences<_$AppDatabase, $FocusSettingsTable, FocusSettingsData>
    ),
    FocusSettingsData,
    PrefetchHooks Function()> {
  $$FocusSettingsTableTableManager(_$AppDatabase db, $FocusSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> focusDuration = const Value.absent(),
            Value<int> shortBreakDuration = const Value.absent(),
            Value<int> longBreakDuration = const Value.absent(),
            Value<int> longBreakInterval = const Value.absent(),
            Value<bool> autoStartBreaks = const Value.absent(),
            Value<bool> autoStartPomodoros = const Value.absent(),
          }) =>
              FocusSettingsCompanion(
            id: id,
            focusDuration: focusDuration,
            shortBreakDuration: shortBreakDuration,
            longBreakDuration: longBreakDuration,
            longBreakInterval: longBreakInterval,
            autoStartBreaks: autoStartBreaks,
            autoStartPomodoros: autoStartPomodoros,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> focusDuration = const Value.absent(),
            Value<int> shortBreakDuration = const Value.absent(),
            Value<int> longBreakDuration = const Value.absent(),
            Value<int> longBreakInterval = const Value.absent(),
            Value<bool> autoStartBreaks = const Value.absent(),
            Value<bool> autoStartPomodoros = const Value.absent(),
          }) =>
              FocusSettingsCompanion.insert(
            id: id,
            focusDuration: focusDuration,
            shortBreakDuration: shortBreakDuration,
            longBreakDuration: longBreakDuration,
            longBreakInterval: longBreakInterval,
            autoStartBreaks: autoStartBreaks,
            autoStartPomodoros: autoStartPomodoros,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FocusSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FocusSettingsTable,
    FocusSettingsData,
    $$FocusSettingsTableFilterComposer,
    $$FocusSettingsTableOrderingComposer,
    $$FocusSettingsTableAnnotationComposer,
    $$FocusSettingsTableCreateCompanionBuilder,
    $$FocusSettingsTableUpdateCompanionBuilder,
    (
      FocusSettingsData,
      BaseReferences<_$AppDatabase, $FocusSettingsTable, FocusSettingsData>
    ),
    FocusSettingsData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitCompletionsTableTableManager get habitCompletions =>
      $$HabitCompletionsTableTableManager(_db, _db.habitCompletions);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db, _db.diaries);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$FocusSettingsTableTableManager get focusSettings =>
      $$FocusSettingsTableTableManager(_db, _db.focusSettings);
}
