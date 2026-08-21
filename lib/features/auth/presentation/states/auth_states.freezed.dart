// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegistrationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(RegistrationResponse response) success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(RegistrationResponse response)? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(RegistrationResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RegistrationInitial value) initial,
    required TResult Function(_RegistrationLoading value) loading,
    required TResult Function(_RegistrationSuccess value) success,
    required TResult Function(_RegistrationError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RegistrationInitial value)? initial,
    TResult? Function(_RegistrationLoading value)? loading,
    TResult? Function(_RegistrationSuccess value)? success,
    TResult? Function(_RegistrationError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RegistrationInitial value)? initial,
    TResult Function(_RegistrationLoading value)? loading,
    TResult Function(_RegistrationSuccess value)? success,
    TResult Function(_RegistrationError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStateCopyWith<$Res> {
  factory $RegistrationStateCopyWith(
    RegistrationState value,
    $Res Function(RegistrationState) then,
  ) = _$RegistrationStateCopyWithImpl<$Res, RegistrationState>;
}

/// @nodoc
class _$RegistrationStateCopyWithImpl<$Res, $Val extends RegistrationState>
    implements $RegistrationStateCopyWith<$Res> {
  _$RegistrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RegistrationInitialImplCopyWith<$Res> {
  factory _$$RegistrationInitialImplCopyWith(
    _$RegistrationInitialImpl value,
    $Res Function(_$RegistrationInitialImpl) then,
  ) = __$$RegistrationInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RegistrationInitialImplCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$RegistrationInitialImpl>
    implements _$$RegistrationInitialImplCopyWith<$Res> {
  __$$RegistrationInitialImplCopyWithImpl(
    _$RegistrationInitialImpl _value,
    $Res Function(_$RegistrationInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RegistrationInitialImpl implements _RegistrationInitial {
  const _$RegistrationInitialImpl();

  @override
  String toString() {
    return 'RegistrationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(RegistrationResponse response) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(RegistrationResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(RegistrationResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RegistrationInitial value) initial,
    required TResult Function(_RegistrationLoading value) loading,
    required TResult Function(_RegistrationSuccess value) success,
    required TResult Function(_RegistrationError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RegistrationInitial value)? initial,
    TResult? Function(_RegistrationLoading value)? loading,
    TResult? Function(_RegistrationSuccess value)? success,
    TResult? Function(_RegistrationError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RegistrationInitial value)? initial,
    TResult Function(_RegistrationLoading value)? loading,
    TResult Function(_RegistrationSuccess value)? success,
    TResult Function(_RegistrationError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _RegistrationInitial implements RegistrationState {
  const factory _RegistrationInitial() = _$RegistrationInitialImpl;
}

/// @nodoc
abstract class _$$RegistrationLoadingImplCopyWith<$Res> {
  factory _$$RegistrationLoadingImplCopyWith(
    _$RegistrationLoadingImpl value,
    $Res Function(_$RegistrationLoadingImpl) then,
  ) = __$$RegistrationLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RegistrationLoadingImplCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$RegistrationLoadingImpl>
    implements _$$RegistrationLoadingImplCopyWith<$Res> {
  __$$RegistrationLoadingImplCopyWithImpl(
    _$RegistrationLoadingImpl _value,
    $Res Function(_$RegistrationLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RegistrationLoadingImpl implements _RegistrationLoading {
  const _$RegistrationLoadingImpl();

  @override
  String toString() {
    return 'RegistrationState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(RegistrationResponse response) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(RegistrationResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(RegistrationResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RegistrationInitial value) initial,
    required TResult Function(_RegistrationLoading value) loading,
    required TResult Function(_RegistrationSuccess value) success,
    required TResult Function(_RegistrationError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RegistrationInitial value)? initial,
    TResult? Function(_RegistrationLoading value)? loading,
    TResult? Function(_RegistrationSuccess value)? success,
    TResult? Function(_RegistrationError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RegistrationInitial value)? initial,
    TResult Function(_RegistrationLoading value)? loading,
    TResult Function(_RegistrationSuccess value)? success,
    TResult Function(_RegistrationError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _RegistrationLoading implements RegistrationState {
  const factory _RegistrationLoading() = _$RegistrationLoadingImpl;
}

/// @nodoc
abstract class _$$RegistrationSuccessImplCopyWith<$Res> {
  factory _$$RegistrationSuccessImplCopyWith(
    _$RegistrationSuccessImpl value,
    $Res Function(_$RegistrationSuccessImpl) then,
  ) = __$$RegistrationSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RegistrationResponse response});
}

/// @nodoc
class __$$RegistrationSuccessImplCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$RegistrationSuccessImpl>
    implements _$$RegistrationSuccessImplCopyWith<$Res> {
  __$$RegistrationSuccessImplCopyWithImpl(
    _$RegistrationSuccessImpl _value,
    $Res Function(_$RegistrationSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? response = null}) {
    return _then(
      _$RegistrationSuccessImpl(
        response: null == response
            ? _value.response
            : response // ignore: cast_nullable_to_non_nullable
                  as RegistrationResponse,
      ),
    );
  }
}

/// @nodoc

class _$RegistrationSuccessImpl implements _RegistrationSuccess {
  const _$RegistrationSuccessImpl({required this.response});

  @override
  final RegistrationResponse response;

  @override
  String toString() {
    return 'RegistrationState.success(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationSuccessImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationSuccessImplCopyWith<_$RegistrationSuccessImpl> get copyWith =>
      __$$RegistrationSuccessImplCopyWithImpl<_$RegistrationSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(RegistrationResponse response) success,
    required TResult Function(String message) error,
  }) {
    return success(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(RegistrationResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(RegistrationResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RegistrationInitial value) initial,
    required TResult Function(_RegistrationLoading value) loading,
    required TResult Function(_RegistrationSuccess value) success,
    required TResult Function(_RegistrationError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RegistrationInitial value)? initial,
    TResult? Function(_RegistrationLoading value)? loading,
    TResult? Function(_RegistrationSuccess value)? success,
    TResult? Function(_RegistrationError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RegistrationInitial value)? initial,
    TResult Function(_RegistrationLoading value)? loading,
    TResult Function(_RegistrationSuccess value)? success,
    TResult Function(_RegistrationError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _RegistrationSuccess implements RegistrationState {
  const factory _RegistrationSuccess({
    required final RegistrationResponse response,
  }) = _$RegistrationSuccessImpl;

  RegistrationResponse get response;

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationSuccessImplCopyWith<_$RegistrationSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegistrationErrorImplCopyWith<$Res> {
  factory _$$RegistrationErrorImplCopyWith(
    _$RegistrationErrorImpl value,
    $Res Function(_$RegistrationErrorImpl) then,
  ) = __$$RegistrationErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RegistrationErrorImplCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$RegistrationErrorImpl>
    implements _$$RegistrationErrorImplCopyWith<$Res> {
  __$$RegistrationErrorImplCopyWithImpl(
    _$RegistrationErrorImpl _value,
    $Res Function(_$RegistrationErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$RegistrationErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RegistrationErrorImpl implements _RegistrationError {
  const _$RegistrationErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'RegistrationState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationErrorImplCopyWith<_$RegistrationErrorImpl> get copyWith =>
      __$$RegistrationErrorImplCopyWithImpl<_$RegistrationErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(RegistrationResponse response) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(RegistrationResponse response)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(RegistrationResponse response)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RegistrationInitial value) initial,
    required TResult Function(_RegistrationLoading value) loading,
    required TResult Function(_RegistrationSuccess value) success,
    required TResult Function(_RegistrationError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RegistrationInitial value)? initial,
    TResult? Function(_RegistrationLoading value)? loading,
    TResult? Function(_RegistrationSuccess value)? success,
    TResult? Function(_RegistrationError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RegistrationInitial value)? initial,
    TResult Function(_RegistrationLoading value)? loading,
    TResult Function(_RegistrationSuccess value)? success,
    TResult Function(_RegistrationError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _RegistrationError implements RegistrationState {
  const factory _RegistrationError({required final String message}) =
      _$RegistrationErrorImpl;

  String get message;

  /// Create a copy of RegistrationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationErrorImplCopyWith<_$RegistrationErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OtpVerificationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(OtpVerificationResult result) success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(OtpVerificationResult result)? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(OtpVerificationResult result)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OtpVerificationInitial value) initial,
    required TResult Function(_OtpVerificationLoading value) loading,
    required TResult Function(_OtpVerificationSuccess value) success,
    required TResult Function(_OtpVerificationError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_OtpVerificationInitial value)? initial,
    TResult? Function(_OtpVerificationLoading value)? loading,
    TResult? Function(_OtpVerificationSuccess value)? success,
    TResult? Function(_OtpVerificationError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OtpVerificationInitial value)? initial,
    TResult Function(_OtpVerificationLoading value)? loading,
    TResult Function(_OtpVerificationSuccess value)? success,
    TResult Function(_OtpVerificationError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerificationStateCopyWith<$Res> {
  factory $OtpVerificationStateCopyWith(
    OtpVerificationState value,
    $Res Function(OtpVerificationState) then,
  ) = _$OtpVerificationStateCopyWithImpl<$Res, OtpVerificationState>;
}

/// @nodoc
class _$OtpVerificationStateCopyWithImpl<
  $Res,
  $Val extends OtpVerificationState
>
    implements $OtpVerificationStateCopyWith<$Res> {
  _$OtpVerificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OtpVerificationInitialImplCopyWith<$Res> {
  factory _$$OtpVerificationInitialImplCopyWith(
    _$OtpVerificationInitialImpl value,
    $Res Function(_$OtpVerificationInitialImpl) then,
  ) = __$$OtpVerificationInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OtpVerificationInitialImplCopyWithImpl<$Res>
    extends
        _$OtpVerificationStateCopyWithImpl<$Res, _$OtpVerificationInitialImpl>
    implements _$$OtpVerificationInitialImplCopyWith<$Res> {
  __$$OtpVerificationInitialImplCopyWithImpl(
    _$OtpVerificationInitialImpl _value,
    $Res Function(_$OtpVerificationInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OtpVerificationInitialImpl implements _OtpVerificationInitial {
  const _$OtpVerificationInitialImpl();

  @override
  String toString() {
    return 'OtpVerificationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerificationInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(OtpVerificationResult result) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(OtpVerificationResult result)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(OtpVerificationResult result)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OtpVerificationInitial value) initial,
    required TResult Function(_OtpVerificationLoading value) loading,
    required TResult Function(_OtpVerificationSuccess value) success,
    required TResult Function(_OtpVerificationError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_OtpVerificationInitial value)? initial,
    TResult? Function(_OtpVerificationLoading value)? loading,
    TResult? Function(_OtpVerificationSuccess value)? success,
    TResult? Function(_OtpVerificationError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OtpVerificationInitial value)? initial,
    TResult Function(_OtpVerificationLoading value)? loading,
    TResult Function(_OtpVerificationSuccess value)? success,
    TResult Function(_OtpVerificationError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _OtpVerificationInitial implements OtpVerificationState {
  const factory _OtpVerificationInitial() = _$OtpVerificationInitialImpl;
}

/// @nodoc
abstract class _$$OtpVerificationLoadingImplCopyWith<$Res> {
  factory _$$OtpVerificationLoadingImplCopyWith(
    _$OtpVerificationLoadingImpl value,
    $Res Function(_$OtpVerificationLoadingImpl) then,
  ) = __$$OtpVerificationLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OtpVerificationLoadingImplCopyWithImpl<$Res>
    extends
        _$OtpVerificationStateCopyWithImpl<$Res, _$OtpVerificationLoadingImpl>
    implements _$$OtpVerificationLoadingImplCopyWith<$Res> {
  __$$OtpVerificationLoadingImplCopyWithImpl(
    _$OtpVerificationLoadingImpl _value,
    $Res Function(_$OtpVerificationLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OtpVerificationLoadingImpl implements _OtpVerificationLoading {
  const _$OtpVerificationLoadingImpl();

  @override
  String toString() {
    return 'OtpVerificationState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerificationLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(OtpVerificationResult result) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(OtpVerificationResult result)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(OtpVerificationResult result)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OtpVerificationInitial value) initial,
    required TResult Function(_OtpVerificationLoading value) loading,
    required TResult Function(_OtpVerificationSuccess value) success,
    required TResult Function(_OtpVerificationError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_OtpVerificationInitial value)? initial,
    TResult? Function(_OtpVerificationLoading value)? loading,
    TResult? Function(_OtpVerificationSuccess value)? success,
    TResult? Function(_OtpVerificationError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OtpVerificationInitial value)? initial,
    TResult Function(_OtpVerificationLoading value)? loading,
    TResult Function(_OtpVerificationSuccess value)? success,
    TResult Function(_OtpVerificationError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _OtpVerificationLoading implements OtpVerificationState {
  const factory _OtpVerificationLoading() = _$OtpVerificationLoadingImpl;
}

/// @nodoc
abstract class _$$OtpVerificationSuccessImplCopyWith<$Res> {
  factory _$$OtpVerificationSuccessImplCopyWith(
    _$OtpVerificationSuccessImpl value,
    $Res Function(_$OtpVerificationSuccessImpl) then,
  ) = __$$OtpVerificationSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OtpVerificationResult result});
}

/// @nodoc
class __$$OtpVerificationSuccessImplCopyWithImpl<$Res>
    extends
        _$OtpVerificationStateCopyWithImpl<$Res, _$OtpVerificationSuccessImpl>
    implements _$$OtpVerificationSuccessImplCopyWith<$Res> {
  __$$OtpVerificationSuccessImplCopyWithImpl(
    _$OtpVerificationSuccessImpl _value,
    $Res Function(_$OtpVerificationSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = null}) {
    return _then(
      _$OtpVerificationSuccessImpl(
        result: null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as OtpVerificationResult,
      ),
    );
  }
}

/// @nodoc

class _$OtpVerificationSuccessImpl implements _OtpVerificationSuccess {
  const _$OtpVerificationSuccessImpl({required this.result});

  @override
  final OtpVerificationResult result;

  @override
  String toString() {
    return 'OtpVerificationState.success(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerificationSuccessImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerificationSuccessImplCopyWith<_$OtpVerificationSuccessImpl>
  get copyWith =>
      __$$OtpVerificationSuccessImplCopyWithImpl<_$OtpVerificationSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(OtpVerificationResult result) success,
    required TResult Function(String message) error,
  }) {
    return success(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(OtpVerificationResult result)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(OtpVerificationResult result)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OtpVerificationInitial value) initial,
    required TResult Function(_OtpVerificationLoading value) loading,
    required TResult Function(_OtpVerificationSuccess value) success,
    required TResult Function(_OtpVerificationError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_OtpVerificationInitial value)? initial,
    TResult? Function(_OtpVerificationLoading value)? loading,
    TResult? Function(_OtpVerificationSuccess value)? success,
    TResult? Function(_OtpVerificationError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OtpVerificationInitial value)? initial,
    TResult Function(_OtpVerificationLoading value)? loading,
    TResult Function(_OtpVerificationSuccess value)? success,
    TResult Function(_OtpVerificationError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _OtpVerificationSuccess implements OtpVerificationState {
  const factory _OtpVerificationSuccess({
    required final OtpVerificationResult result,
  }) = _$OtpVerificationSuccessImpl;

  OtpVerificationResult get result;

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpVerificationSuccessImplCopyWith<_$OtpVerificationSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OtpVerificationErrorImplCopyWith<$Res> {
  factory _$$OtpVerificationErrorImplCopyWith(
    _$OtpVerificationErrorImpl value,
    $Res Function(_$OtpVerificationErrorImpl) then,
  ) = __$$OtpVerificationErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$OtpVerificationErrorImplCopyWithImpl<$Res>
    extends _$OtpVerificationStateCopyWithImpl<$Res, _$OtpVerificationErrorImpl>
    implements _$$OtpVerificationErrorImplCopyWith<$Res> {
  __$$OtpVerificationErrorImplCopyWithImpl(
    _$OtpVerificationErrorImpl _value,
    $Res Function(_$OtpVerificationErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$OtpVerificationErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OtpVerificationErrorImpl implements _OtpVerificationError {
  const _$OtpVerificationErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'OtpVerificationState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerificationErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerificationErrorImplCopyWith<_$OtpVerificationErrorImpl>
  get copyWith =>
      __$$OtpVerificationErrorImplCopyWithImpl<_$OtpVerificationErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(OtpVerificationResult result) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(OtpVerificationResult result)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(OtpVerificationResult result)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_OtpVerificationInitial value) initial,
    required TResult Function(_OtpVerificationLoading value) loading,
    required TResult Function(_OtpVerificationSuccess value) success,
    required TResult Function(_OtpVerificationError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_OtpVerificationInitial value)? initial,
    TResult? Function(_OtpVerificationLoading value)? loading,
    TResult? Function(_OtpVerificationSuccess value)? success,
    TResult? Function(_OtpVerificationError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_OtpVerificationInitial value)? initial,
    TResult Function(_OtpVerificationLoading value)? loading,
    TResult Function(_OtpVerificationSuccess value)? success,
    TResult Function(_OtpVerificationError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _OtpVerificationError implements OtpVerificationState {
  const factory _OtpVerificationError({required final String message}) =
      _$OtpVerificationErrorImpl;

  String get message;

  /// Create a copy of OtpVerificationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpVerificationErrorImplCopyWith<_$OtpVerificationErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
