import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_parents.dart';
import '../../domain/usecases/add_parent.dart';
import '../../domain/usecases/update_parent.dart';
import '../../domain/usecases/delete_parent.dart';
import '../../domain/usecases/login_parent.dart';
import '../../domain/usecases/logout_parent.dart';
import '../../domain/usecases/get_parent_by_id.dart';

import 'parent_event.dart';
import 'parent_state.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final GetAllParents getAllParents;
  final AddParent addParent;
  final UpdateParent updateParent;
  final DeleteParent deleteParent;
  final LoginParent loginParent;
  final LogoutParent logoutParent;
  final GetParentById getParentById;

  ParentBloc({
    required this.getAllParents,
    required this.addParent,
    required this.updateParent,
    required this.deleteParent,
    required this.loginParent,
    required this.logoutParent,
    required this.getParentById,
  }) : super(ParentInitial()) {
    // 🔹 LOAD ALL
    on<LoadParents>((event, emit) async {
      emit(ParentLoading());
      try {
        final parents = await getAllParents();
        emit(ParentsLoaded(parents));
      } catch (e) {
        emit(ParentError("Erreur chargement parents"));
      }
    });

    // 🔹 ADD
    on<AddParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await addParent(event.parent);
        add(LoadParents());
      } catch (e) {
        emit(ParentError("Erreur ajout parent"));
      }
    });

    // 🔹 UPDATE
    on<UpdateParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await updateParent(event.parent);
        add(LoadParents());
      } catch (e) {
        emit(ParentError("Erreur modification parent"));
      }
    });

    // 🔹 DELETE
    on<DeleteParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await deleteParent(event.id);
        add(LoadParents());
      } catch (e) {
        emit(ParentError("Erreur suppression parent"));
      }
    });

    // 🔹 LOGIN
    on<LoginParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        final parent = await loginParent(
          email: event.email,
          password: event.password,
        );

        if (parent != null) {
          emit(ParentLoggedIn(parent));
        } else {
          emit(ParentError("Email ou mot de passe incorrect"));
        }
      } catch (e) {
        emit(ParentError("Erreur connexion"));
      }
    });

    // 🔹 LOGOUT
    on<LogoutParentEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        await logoutParent();
        emit(ParentLoggedOut());
      } catch (e) {
        emit(ParentError("Erreur déconnexion"));
      }
    });

    // 🔹 GET BY ID
    on<GetParentByIdEvent>((event, emit) async {
      emit(ParentLoading());
      try {
        final parent = await getParentById(event.id);
        if (parent != null) {
          emit(ParentLoaded(parent));
        } else {
          emit(ParentError("Parent introuvable"));
        }
      } catch (e) {
        emit(ParentError("Erreur chargement parent"));
      }
    });
  }
}
