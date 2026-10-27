import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'To-Do List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B57C8)),
          scaffoldBackgroundColor: const Color(0xFFF6F6FB),
        ),
        home: const TodoPage(),
      );
}

class Todo {
  Todo(this.title, {this.done = false});
  final String title;
  bool done;
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  final List<Todo> _tasks = [];

  int get _remaining => _tasks.where((task) => !task.done).length;

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    setState(() {
      _tasks.add(Todo(title));
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('$_remaining left')),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _addTask(),
                            decoration: InputDecoration(
                              hintText: 'What needs doing?',
                              prefixIcon: const Icon(Icons.edit_note),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton.icon(
                          onPressed: _addTask,
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _tasks.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.task_alt, size: 52, color: Colors.grey),
                                SizedBox(height: 10),
                                Text('Nothing here yet. Add your first task.'),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
                            itemCount: _tasks.length,
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 9),
                                child: Dismissible(
                                  key: ObjectKey(task),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(Icons.delete_outline),
                                  ),
                                  onDismissed: (_) => setState(() => _tasks.remove(task)),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    color: Colors.white,
                                    elevation: 0,
                                    child: CheckboxListTile(
                                      value: task.done,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      title: Text(
                                        task.title,
                                        style: TextStyle(
                                          decoration: task.done
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: task.done ? Colors.grey : null,
                                        ),
                                      ),
                                      onChanged: (value) => setState(
                                        () => task.done = value ?? false,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

