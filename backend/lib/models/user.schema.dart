// ignore_for_file: annotate_overrides

part of 'user.dart';

extension UserRepositories on Database {
  UserRepository get users => UserRepository._(this);
}

abstract class UserRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<UserInsertRequest>,
        ModelRepositoryUpdate<UserUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory UserRepository._(Database db) = _UserRepository;

  Future<UserView?> queryUser(String id);
  Future<List<UserView>> queryUsers([QueryParams? params]);
}

class _UserRepository extends BaseRepository
    with
        RepositoryInsertMixin<UserInsertRequest>,
        RepositoryUpdateMixin<UserUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements UserRepository {
  _UserRepository(super.db) : super(tableName: 'users', keyName: 'id');

  @override
  Future<UserView?> queryUser(String id) {
    return queryOne(id, UserViewQueryable());
  }

  @override
  Future<List<UserView>> queryUsers([QueryParams? params]) {
    return queryMany(UserViewQueryable(), params);
  }

  @override
  Future<void> insert(List<UserInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "users" ( "id", "full_name", "email", "password", "avatar_url", "following", "follower" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.fullName)}:text, ${values.add(r.email)}:text, ${values.add(r.password)}:text, ${values.add(r.avatarUrl)}:text, ${values.add(r.following)}:int8, ${values.add(r.follower)}:int8 )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<UserUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "users"\n'
      'SET "full_name" = COALESCE(UPDATED."full_name", "users"."full_name"), "email" = COALESCE(UPDATED."email", "users"."email"), "password" = COALESCE(UPDATED."password", "users"."password"), "avatar_url" = COALESCE(UPDATED."avatar_url", "users"."avatar_url"), "following" = COALESCE(UPDATED."following", "users"."following"), "follower" = COALESCE(UPDATED."follower", "users"."follower")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.fullName)}:text::text, ${values.add(r.email)}:text::text, ${values.add(r.password)}:text::text, ${values.add(r.avatarUrl)}:text::text, ${values.add(r.following)}:int8::int8, ${values.add(r.follower)}:int8::int8 )').join(', ')} )\n'
      'AS UPDATED("id", "full_name", "email", "password", "avatar_url", "following", "follower")\n'
      'WHERE "users"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class UserInsertRequest {
  UserInsertRequest({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.avatarUrl,
    required this.following,
    required this.follower,
  });

  final String id;
  final String fullName;
  final String email;
  final String password;
  final String? avatarUrl;
  final int following;
  final int follower;
}

class UserUpdateRequest {
  UserUpdateRequest({
    required this.id,
    this.fullName,
    this.email,
    this.password,
    this.avatarUrl,
    this.following,
    this.follower,
  });

  final String id;
  final String? fullName;
  final String? email;
  final String? password;
  final String? avatarUrl;
  final int? following;
  final int? follower;
}

class UserViewQueryable extends KeyedViewQueryable<UserView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "users".*'
      'FROM "users"';

  @override
  String get tableAlias => 'users';

  @override
  UserView decode(TypedMap map) => UserView(
      id: map.get('id'),
      fullName: map.get('full_name'),
      email: map.get('email'),
      password: map.get('password'),
      avatarUrl: map.getOpt('avatar_url'),
      following: map.get('following'),
      follower: map.get('follower'));
}

class UserView {
  UserView({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.avatarUrl,
    required this.following,
    required this.follower,
  });

  final String id;
  final String fullName;
  final String email;
  final String password;
  final String? avatarUrl;
  final int following;
  final int follower;
}
