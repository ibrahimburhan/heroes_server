import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  test("GET /heroes returns 200 OK", () async {
    final response = await harness.agent.get("/heroes");
    expectResponse(response, 200);
  });
}