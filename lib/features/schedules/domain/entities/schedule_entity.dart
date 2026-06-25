// ============================================================
// FICHIER : domain/entities/schedule_entity.dart
//
// RÔLE : Représentation "pure" d'un créneau d'emploi du temps.
// Aucune dépendance Firebase ou Flutter ici — juste du Dart.
//
// Un ScheduleEntity représente UN créneau :
//   ex → "6ème A | Lundi | Maths | M.Martin | 08:00 – 10:00 | Salle 12"
//
// Champs :
//   id        → identifiant Firestore (vide à la création)
//   classId   → id de la classe concernée
//   className → nom de la classe (ex : "6ème A")
//   day       → jour de la semaine (ex : "Lundi")
//   subject   → matière enseignée (ex : "Mathématiques")
//   teacher   → nom de l'enseignant
//   startTime → heure de début (ex : "08:00")
//   endTime   → heure de fin   (ex : "10:00")
//   room      → salle ou lieu  (ex : "Salle 12")
//   createdAt → date d'enregistrement dans Firestore
// ============================================================

class ScheduleEntity {
  final String id;
  final String classId;
  final String className;
  final String day;
  final String subject;
  final String teacher;
  final String startTime;
  final String endTime;
  final String room;
  final DateTime createdAt;

  const ScheduleEntity({
    required this.id,
    required this.classId,
    required this.className,
    required this.day,
    required this.subject,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.createdAt,
  });

  // copyWith : crée une copie en modifiant seulement certains champs.
  // Exemple : schedule.copyWith(room: 'Salle 5')
  // → conserve tout sauf la salle qui devient 'Salle 5'.
  ScheduleEntity copyWith({
    String? id,
    String? classId,
    String? className,
    String? day,
    String? subject,
    String? teacher,
    String? startTime,
    String? endTime,
    String? room,
    DateTime? createdAt,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      day: day ?? this.day,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
