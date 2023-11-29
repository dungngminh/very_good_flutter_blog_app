// ignore_for_file: annotate_overrides

part of 'favorite_blogs_users.dart';

extension FavoriteBlogsUsersRepositories on Database {
  FavoriteBlogsUsersRepository get favoriteBlogsUserses => FavoriteBlogsUsersRepository._(this);
}

abstract class FavoriteBlogsUsersRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<FavoriteBlogsUsersInsertRequest>,
        ModelRepositoryUpdate<FavoriteBlogsUsersUpdateRequest> {
  factory FavoriteBlogsUsersRepository._(Database db) = _FavoriteBlogsUsersRepository;

  Future<List<FavoriteBlogsUsersView>> queryFavoriteBlogsUserses([QueryParams? params]);
}

class _FavoriteBlogsUsersRepository extends BaseRepository
    with
        RepositoryInsertMixin<FavoriteBlogsUsersInsertRequest>,
        RepositoryUpdateMixin<FavoriteBlogsUsersUpdateRequest>
    implements FavoriteBlogsUsersRepository {
  _FavoriteBlogsUsersRepository(super.db) : super(tableName: 'favorite_blogs_userses');

  @override
  Future<List<FavoriteBlogsUsersView>> queryFavoriteBlogsUserses([QueryParams? params]) {
    return queryMany(FavoriteBlogsUsersViewQueryable(), params);
  }

  @override
  Future<void> insert(List<FavoriteBlogsUsersInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "favorite_blogs_userses" ( "blog_id", "user_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.blogId)}:text, ${values.add(r.userId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<FavoriteBlogsUsersUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "favorite_blogs_userses"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.blogId)}:text::text, ${values.add(r.userId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("blog_id", "user_id")\n'
      'WHERE "favorite_blogs_userses"."blog_id" = UPDATED."blog_id" AND "favorite_blogs_userses"."user_id" = UPDATED."user_id"',
      values.values,
    );
  }
}

class FavoriteBlogsUsersInsertRequest {
  FavoriteBlogsUsersInsertRequest({
    required this.blogId,
    required this.userId,
  });

  final String blogId;
  final String userId;
}

class FavoriteBlogsUsersUpdateRequest {
  FavoriteBlogsUsersUpdateRequest({
    this.blogId,
    this.userId,
  });

  final String? blogId;
  final String? userId;
}

class FavoriteBlogsUsersViewQueryable extends ViewQueryable<FavoriteBlogsUsersView> {
  @override
  String get query =>
      'SELECT "favorite_blogs_userses".*, row_to_json("blog".*) as "blog", row_to_json("user".*) as "user"'
      'FROM "favorite_blogs_userses"'
      'LEFT JOIN (${BlogViewQueryable().query}) "blog"'
      'ON "favorite_blogs_userses"."blog_id" = "blog"."id"'
      'LEFT JOIN (${UserViewQueryable().query}) "user"'
      'ON "favorite_blogs_userses"."user_id" = "user"."id"';

  @override
  String get tableAlias => 'favorite_blogs_userses';

  @override
  FavoriteBlogsUsersView decode(TypedMap map) => FavoriteBlogsUsersView(
      blog: map.get('blog', BlogViewQueryable().decoder),
      user: map.get('user', UserViewQueryable().decoder));
}

class FavoriteBlogsUsersView {
  FavoriteBlogsUsersView({
    required this.blog,
    required this.user,
  });

  final BlogView blog;
  final UserView user;
}
