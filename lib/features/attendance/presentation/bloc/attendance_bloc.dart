import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

/// -----------------------------------------------------------------------
/// AttendanceBloc
/// -----------------------------------------------------------------------
/// Le "cerveau" de la fonctionnalité Attendance côté Presentation.
///
/// Il reçoit des événements (LoadAttendance, AddAttendance, ...), appelle
/// l'AttendanceRepository (Domain), puis émet un état (AttendanceLoading,
/// AttendanceLoaded, AttendanceError...) que l'UI affichera.
///
/// Le bloc ne contient AUCUNE logique Firestore : tout est délégué au
/// repository, ce qui garde le bloc simple et testable.
/// -----------------------------------------------------------------------
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;

  AttendanceBloc(this.repository) : super(AttendanceInitial()) {
    on<LoadAttendance>(_onLoadAttendance);
    on<AddAttendance>(_onAddAttendance);
    on<UpdateAttendance>(_onUpdateAttendance);
    on<DeleteAttendance>(_onDeleteAttendance);
  }

  Future<void> _onLoadAttendance(
    LoadAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final attendanceList = await repository.getAttendance();
      emit(AttendanceLoaded(attendanceList));
    } catch (e) {
      emit(AttendanceError('Impossible de charger les présences : $e'));
    }
  }

  Future<void> _onAddAttendance(
    AddAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      await repository.addAttendance(event.attendance);
      // On recharge la liste pour que l'UI affiche la nouvelle présence.
      await _onLoadAttendance(LoadAttendance(), emit);
    } catch (e) {
      emit(AttendanceError("Impossible d'ajouter la présence : $e"));
    }
  }

  Future<void> _onUpdateAttendance(
    UpdateAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      await repository.updateAttendance(event.attendance);
      await _onLoadAttendance(LoadAttendance(), emit);
    } catch (e) {
      emit(AttendanceError('Impossible de modifier la présence : $e'));
    }
  }

  Future<void> _onDeleteAttendance(
    DeleteAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      await repository.deleteAttendance(event.attendanceId);
      await _onLoadAttendance(LoadAttendance(), emit);
    } catch (e) {
      emit(AttendanceError('Impossible de supprimer la présence : $e'));
    }
  }
}
