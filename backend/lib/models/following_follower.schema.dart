// ignore_for_file: annotate_overrides

part of 'following_follower.dart';

extension FollowingFollowerRepositories on Database {
  FollowingFollowerRepository get followingFollowers => FollowingFollowerRepository._(this);
}

abstract class FollowingFollowerRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<FollowingFollowerInsertRequest>,
        ModelRepositoryUpdate<FollowingFollowerUpdateRequest> {
  factory FollowingFollowerRepository._(Database db) = _FollowingFollowerRepository;

  Future<List<FollowingFollowerView>> queryFollowingFollowers([QueryParams? params]);
}

class _FollowingFollowerRepository extends BaseRepository
    with
        RepositoryInsertMixin<FollowingFollowerInsertRequest>,
        RepositoryUpdateMixin<FollowingFollowerUpdateRequest>
    implements FollowingFollowerRepository {
  _FollowingFollowerRepository(super.db) : super(tableName: 'following_followers');

  @override
  Future<List<FollowingFollowerView>> queryFollowingFollowers([QueryParams? params]) {
    return queryMany(FollowingFollowerViewQueryable(), params);
  }

  @override
  Future<void> insert(List<FollowingFollowerInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "following_followers" ( "following_id", "follower_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.followingId)}:text, ${values.add(r.followerId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<FollowingFollowerUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "following_followers"\n'
      'SET \n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.followingId)}:text::text, ${values.add(r.followerId)}:text::text )').join(', ')} )\n'
      'AS UPDATED("following_id", "follower_id")\n'
      'WHERE "following_followers"."following_id" = UPDATED."following_id" AND "following_followers"."follower_id" = UPDATED."follower_id"',
      values.values,
    );
  }
}

class FollowingFollowerInsertRequest {
  FollowingFollowerInsertRequest({
    required this.followingId,
    required this.followerId,
  });

  final String followingId;
  final String followerId;
}

class FollowingFollowerUpdateRequest {
  FollowingFollowerUpdateRequest({
    this.followingId,
    this.followerId,
  });

  final String? followingId;
  final String? followerId;
}

class FollowingFollowerViewQueryable extends ViewQueryable<FollowingFollowerView> {
  @override
  String get query =>
      'SELECT "following_followers".*, row_to_json("following".*) as "following", row_to_json("follower".*) as "follower"'
      'FROM "following_followers"'
      'LEFT JOIN (${UserViewQueryable().query}) "following"'
      'ON "following_followers"."following_id" = "following"."id"'
      'LEFT JOIN (${UserViewQueryable().query}) "follower"'
      'ON "following_followers"."follower_id" = "follower"."id"';

  @override
  String get tableAlias => 'following_followers';

  @override
  FollowingFollowerView decode(TypedMap map) => FollowingFollowerView(
      following: map.get('following', UserViewQueryable().decoder),
      follower: map.get('follower', UserViewQueryable().decoder));
}

class FollowingFollowerView {
  FollowingFollowerView({
    required this.following,
    required this.follower,
  });

  final UserView following;
  final UserView follower;
}
