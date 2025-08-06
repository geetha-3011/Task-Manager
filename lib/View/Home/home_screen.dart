import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Model/task_model.dart';
import 'package:task_manager/Services/save_data.dart';
import 'package:task_manager/View/Home/profile_screen.dart';
import 'package:task_manager/View/Home/task_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String? userName;
  String? userEmail;
  String? userUid;

  List<Task> _tasks = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = Uuid();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    fetchTasks();
    loadUserData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
  userName = await SharedPrefsService.getUserName();
  userEmail = await SharedPrefsService.getUserEmail();
  userUid = await SharedPrefsService.getUserUid();
  if (userUid != null) {
    await fetchTasks2();
  }
  setState(() {});
}


Future<void> fetchTasks2() async {
  if (userUid == null) return;
  try {
    final snapshot = await _firestore
        .collection('task')
        .doc(userUid)
        .collection('userTasks')
        .get();

    setState(() {
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    });
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

Future<void> fetchTasks() async {
  if (userUid == null) return;
  try {
    final snapshot = await _firestore
        .collection('task')
        .doc(userUid)
        .collection('userTasks')
        .get();

    setState(() {
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fetch Task Successfully")),
    );
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

Future<void> addTask(Task task) async {
  if (userUid == null) return;
  try {
    final taskId = _uuid.v4();
    task.id = taskId;

    await _firestore
        .collection('task')
        .doc(userUid)
        .collection('userTasks')
        .doc(taskId)
        .set(task.toMap());

    setState(() => _tasks.add(task));
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

Future<void> deleteTask(String id) async {
  if (userUid == null) return;
  try {
    await _firestore
        .collection('task')
        .doc(userUid)
        .collection('userTasks')
        .doc(id)
        .delete();

    setState(() => _tasks.removeWhere((t) => t.id == id));
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

Future<void> updateTask(Task updatedTask) async {
  if (userUid == null) return;
  try {
    await _firestore
        .collection('task')
        .doc(userUid)
        .collection('userTasks')
        .doc(updatedTask.id)
        .update(updatedTask.toMap());

    setState(() {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) _tasks[index] = updatedTask;
    });
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
  }
}

  List<Task> getFilteredTasks(String tab) {
    if (tab == 'All') return _tasks;
    return _tasks.where((task) => task.status == tab.toLowerCase()).toList();
  }

  void _showTaskForm({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TaskForm(
            task: task,
            onSubmit: (t) => task == null ? addTask(t) : updateTask(t),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'open':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'open':
        return Icons.pending;
      default:
        return Icons.task;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Open', 'Completed'];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: fetchTasks,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 200,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade400,
                        Colors.purple.shade400,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Task Manager',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (userName != null && userName!.isNotEmpty)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                '👋 Welcome back, $userName!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            'You have ${_tasks.where((t) => t.status != 'completed').length} pending tasks',
                            style: TextStyle(
                              color: Colors.white.withAlpha(229),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.blue.shade400,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.blue.shade400,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: tabs.map((e) => Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(e),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                children: tabs.map((tab) {
                  final filtered = getFilteredTasks(tab);
                  
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${tab.toLowerCase()} tasks',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a new task',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              
                  return ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final task = filtered[index];
                      final statusColor = _getStatusColor(task.status);
                      final statusIcon = _getStatusIcon(task.status);
                      
                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: tab == "Completed" ? Colors.orange : Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child:  Row(
                            children: [
                              Icon(tab == "Completed" ? Icons.refresh : Icons.check_circle, color: Colors.white, size: 28),
                              SizedBox(width: 12),
                              Text(
                                tab == "Completed" ? "Mark as Open" : "Mark Complete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Delete Task",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.delete_forever, color: Colors.white, size: 28),
                            ],
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await deleteTask(task.id);
                          } else {
                            final updated =
                             task..status = tab == "Completed" ? "open" : "completed";
                            await updateTask(updated);
                          }
                          return true;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _showTaskForm(task: task),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                              decoration: task.status == 'completed' 
                                                  ? TextDecoration.lineThrough 
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            task.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                              decoration: task.status == 'completed' 
                                                  ? TextDecoration.lineThrough 
                                                  : null,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: Colors.grey.shade500,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateFormat('MMM dd, yyyy').format(task.dueDate),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(26),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        statusIcon,
                                        color: statusColor,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.purple.shade400],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withAlpha(77),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showTaskForm(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}