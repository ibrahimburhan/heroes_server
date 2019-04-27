import 'package:aqueduct/aqueduct.dart';
import 'package:heroes/heroes.dart';
import 'package:heroes/model/hero.dart';

class HeroesController extends ResourceController {
  HeroesController(this.context);

  final ManagedContext context;

  final _heroes = [
    {'id': 11, 'name': 'Mr. Nice'},
    {'id': 12, 'name': 'Narco'},
    {'id': 13, 'name': 'Bombasto'},
    {'id': 14, 'name': 'Celeritas'},
    {'id': 15, 'name': 'Magneta'},
  ];

  @Operation.get()
  Future<Response> getAllHeroes({@Bind.query('name') String name}) async {
    final heroQuery = Query<Hero>(context);
    if (name != null) {
      heroQuery.where((h) => h.name).contains(name, caseSensitive: false);
    }
    final heroes = await heroQuery.fetch();

    return Response.ok(heroes);
  }

  @Operation.get('id')
  Future<Response> getHeroByID(@Bind.path('id') int id) async {
    final heroQuery = Query<Hero>(context)
      ..where((h) => h.id).equalTo(id);

    final hero = await heroQuery.fetchOne();

    if (hero == null) {
      return Response.notFound();
    }
    return Response.ok(hero);
  }

  @Operation.post()
  Future<Response> createHero(@Bind.body(ignore: ["id"]) Hero inputHero) async {
    final query = Query<Hero>(context)
      ..values = inputHero;

    final insertedHero = await query.insert();

    return Response.ok(insertedHero);
  }

  @Operation.put('id')
  Future<Response> updateHeroById(@Bind.path('id') int id ,@Bind.body() Hero inputHero) async {
    print("Updated name: " + inputHero.name);

    final heroQuery = Query<Hero>(context)
      ..values.name = inputHero.name
      ..where((h) => h.id).equalTo(id)
      ;

    print("Updated id: " +heroQuery.values.id.toString());
    print("Updated name: " +heroQuery.values.name);

    final hero = await heroQuery.update();
    if (hero == null) {
      return Response.notFound();
    }
    return Response.ok(hero);
  }

  @Operation.delete('id')
  Future<Response> deleteHeroByID(@Bind.path('id') int id) async {
    final heroQuery = Query<Hero>(context)..where((h) => h.id).equalTo(id);
    final hero = await heroQuery.delete();
    if (hero == null) {
      return Response.notFound();
    }
    return Response.ok(hero);
  }
}