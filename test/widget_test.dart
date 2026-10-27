import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart';

void main() {
  testWidgets('adds, completes, deletes, and counts tasks', (tester) async {
    await tester.pumpWidget(const TodoApp());
    expect(find.text('Nothing here yet. Add your first task.'), findsOneWidget);

    final field = find.byType(TextField);
    await tester.enterText(field, 'Plan the day');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.enterText(field, 'Read a chapter');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('2 left'), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('1 left'), findsOneWidget);

    await tester.drag(find.byType(Dismissible).last, const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Read a chapter'), findsNothing);
    expect(find.text('0 left'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ignores a blank task', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing here yet. Add your first task.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

