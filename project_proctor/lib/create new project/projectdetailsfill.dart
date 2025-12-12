import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/bottom_navigation.dart';
import '../Projects/projects.dart';

// Custom page route with no animation
class _NoAnimationPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  _NoAnimationPageRoute({required this.builder});

  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;
  @override
  bool get opaque => true;
  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

// Subcontractor model
class Subcontractor {
  String name = '';
  String companyName = '';
  String email = '';
  String contactNumber = '';
  String speciality = '';
}

// Task model
class Task {
  String taskName = '';
  String description = '';
  String trade = '';
  DateTime? startDate;
  DateTime? endDate;
  String status = '';
  String priority = '';
  String cost = '';
  List<String> assignedSubcontractors = [];
}

class ProjectDetailsFill extends StatefulWidget {
  final String? templateName; // Template name if coming from template selection
  final List<String>? templateTasks; // Pre-filled tasks from template

  const ProjectDetailsFill({
    super.key,
    this.templateName,
    this.templateTasks,
  });

  @override
  State<ProjectDetailsFill> createState() => _ProjectDetailsFillState();
}

class _ProjectDetailsFillState extends State<ProjectDetailsFill> {
  // Form controllers
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _projectManagerController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Date controllers
  DateTime? _startDate;
  
  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _selectedImages = [];

  // Subcontractors
  List<Subcontractor> _subcontractors = [];
  Set<int> _newlyAddedSubcontractorIndices = {}; // Track newly added items

  // Tasks
  List<Task> _tasks = [];
  Set<int> _newlyAddedTaskIndices = {}; // Track newly added items

  // Current task/subcontractor form controllers
  final Map<int, TextEditingController> _subcontractorNameControllers = {};
  final Map<int, TextEditingController> _subcontractorCompanyControllers = {};
  final Map<int, TextEditingController> _subcontractorEmailControllers = {};
  final Map<int, TextEditingController> _subcontractorContactControllers = {};
  final Map<int, TextEditingController> _subcontractorSpecialityControllers = {};

  final Map<int, TextEditingController> _taskNameControllers = {};
  final Map<int, TextEditingController> _taskDescriptionControllers = {};
  final Map<int, TextEditingController> _taskCostControllers = {};

  // Focus nodes for all fields to track editing state
  final Map<int, FocusNode> _subcontractorNameFocusNodes = {};
  final Map<int, FocusNode> _subcontractorCompanyFocusNodes = {};
  final Map<int, FocusNode> _subcontractorEmailFocusNodes = {};
  final Map<int, FocusNode> _subcontractorContactFocusNodes = {};
  final Map<int, FocusNode> _subcontractorSpecialityFocusNodes = {};
  
  final Map<int, FocusNode> _taskNameFocusNodes = {};
  final Map<int, FocusNode> _taskDescriptionFocusNodes = {};
  final Map<int, FocusNode> _taskCostFocusNodes = {};

  @override
  void initState() {
    super.initState();

    // Auto-fill from template
    if (widget.templateName != null) {
      _projectNameController.text = widget.templateName!;
    }
    if (widget.templateTasks != null && widget.templateTasks!.isNotEmpty) {
      _tasks = [];
      for (int i = 0; i < widget.templateTasks!.length; i++) {
        final task = Task();
        task.taskName = widget.templateTasks![i];
        _taskNameControllers[i] = TextEditingController(text: widget.templateTasks![i]);
        _taskDescriptionControllers[i] = TextEditingController();
        _taskCostControllers[i] = TextEditingController();
        _tasks.add(task);
      }
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _addressController.dispose();
    _ownerNameController.dispose();
    _projectManagerController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    for (var controller in _subcontractorNameControllers.values) {
      controller.dispose();
    }
    for (var controller in _subcontractorCompanyControllers.values) {
      controller.dispose();
    }
    for (var controller in _subcontractorEmailControllers.values) {
      controller.dispose();
    }
    for (var controller in _subcontractorContactControllers.values) {
      controller.dispose();
    }
    for (var controller in _subcontractorSpecialityControllers.values) {
      controller.dispose();
    }
    for (var controller in _taskNameControllers.values) {
      controller.dispose();
    }
    for (var controller in _taskDescriptionControllers.values) {
      controller.dispose();
    }
    for (var controller in _taskCostControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _subcontractorNameFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _subcontractorCompanyFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _subcontractorEmailFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _subcontractorContactFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _subcontractorSpecialityFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _taskNameFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _taskDescriptionFocusNodes.values) {
      focusNode.dispose();
    }
    for (var focusNode in _taskCostFocusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Colors
  static const primaryBlue = Color(0xFF155DFC);
  static const primaryBlueDark = Color(0xFF1447E6);
  static const bgGray100 = Color(0xFFF3F4F6);
  static const textGray900 = Color(0xFF101828);
  static const textGray600 = Color(0xFF6A7282);
  static const textGray400 = Color(0xFF717182);
  static const borderGray100 = Color(0xFFF3F4F6);
  static const borderGray200 = Color(0xFFE5E7EB);
  static const textDark = Color(0xFF101828);
  static const textGray = Color(0xFF6A7282);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 165.0;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          } else if (index == 1) {
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const ProjectsPage(),
              ),
              (route) => false,
            );
          } else if (index == 2) {
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const ProjectsPage(),
              ),
              (route) => false,
            );
          }
        },
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF8FAFC),
                Colors.white,
                const Color(0xFFEFF6FF),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(scale),
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 9.318 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12 * scale),
                      // Project Name
                      _buildInputField(
                        scale,
                        icon: Icons.laptop,
                        label: 'Project Name',
                        controller: _projectNameController,
                        hint: 'Industrial Facility',
                      ),
                      SizedBox(height: 12 * scale),
                      // Project Address
                      _buildInputField(
                        scale,
                        icon: Icons.location_on,
                        label: 'Project Address',
                        controller: _addressController,
                        hint: '123 Main Street, City, State, ZIP',
                      ),
                      SizedBox(height: 12 * scale),
                      // Owner Name
                      _buildInputField(
                        scale,
                        icon: Icons.person,
                        label: 'Owner Name',
                        controller: _ownerNameController,
                        hint: 'e.g., John Smith',
                      ),
                      SizedBox(height: 12 * scale),
                      // Project Manager
                      _buildInputField(
                        scale,
                        icon: Icons.person_outline,
                        label: 'Project Manager',
                        controller: _projectManagerController,
                        hint: 'e.g., Sarah Johnson',
                      ),
                      SizedBox(height: 12 * scale),
                      // Start Date
                      _buildDateField(
                        scale,
                        icon: Icons.calendar_today,
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _selectDate(context, scale, isStartDate: true),
                      ),
                      SizedBox(height: 12 * scale),
                      // Budget
                      _buildInputField(
                        scale,
                        icon: Icons.attach_money,
                        label: 'Budget',
                        controller: _budgetController,
                        hint: '2500000',
                      ),
                      SizedBox(height: 12 * scale),
                      // Project Description
                      _buildTextAreaField(
                        scale,
                        label: 'Project Description (Optional)',
                        controller: _descriptionController,
                        hint: 'Add any additional details about the project...',
                      ),
                      SizedBox(height: 12 * scale),
                      // Project Photos
                      _buildProjectPhotos(scale),
                      SizedBox(height: 12 * scale),
                      // Subcontractors
                      _buildSubcontractorsSection(scale),
                      SizedBox(height: 12 * scale),
                      // Tasks
                      _buildTasksSection(scale),
                      SizedBox(height: 20 * scale),
                      // Create Button
                      _buildCreateButton(scale),
                      SizedBox(height: 20 * scale),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Container(
      height: 29.894 * scale,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: borderGray200.withOpacity(0.5),
            width: 0.388 * scale,
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 6.212 * scale),
      child: Row(
        children: [
          // Back Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: Container(
                width: 15.529 * scale,
                height: 15.529 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: borderGray200,
                    width: 0.388 * scale,
                  ),
                  borderRadius: BorderRadius.circular(5.435 * scale),
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 7.765 * scale,
                  color: textGray900,
                ),
              ),
            ),
          ),
          SizedBox(width: 6.212 * scale),
          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create New Project',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.212 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray900,
                  ),
                ),
                Text(
                  'Fill in the project details',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 5.435 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    double scale, {
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray100,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.153 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 6.212 * scale,
                color: const Color(0xFF364153),
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF364153),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.106 * scale),
          Container(
            height: 17.082 * scale,
            decoration: BoxDecoration(
              color: bgGray100,
              border: Border.all(
                color: borderGray200,
                width: 0.388 * scale,
              ),
              borderRadius: BorderRadius.circular(5.435 * scale),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 4.659 * scale,
              vertical: 1.553 * scale,
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.212 * scale,
                color: textGray400,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.212 * scale,
                  color: textGray400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    double scale, {
    required IconData icon,
    required String label,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray100,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.153 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 6.212 * scale,
                color: const Color(0xFF364153),
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF364153),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.106 * scale),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: Container(
                height: 17.082 * scale,
                padding: EdgeInsets.symmetric(horizontal: 4.659 * scale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        date != null
                            ? '${date.day}/${date.month}/${date.year}'
                            : 'Select a date',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 6.212 * scale,
                          color: date != null ? textGray400 : textGray600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 4 * scale),
                    Icon(
                      Icons.calendar_today,
                      size: 6.212 * scale,
                      color: textGray600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextAreaField(
    double scale, {
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray100,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.153 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 5.435 * scale,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF364153),
            ),
          ),
          SizedBox(height: 3.106 * scale),
          Container(
            height: 38.824 * scale,
            decoration: BoxDecoration(
              color: bgGray100,
              border: Border.all(
                color: borderGray200,
                width: 0.388 * scale,
              ),
              borderRadius: BorderRadius.circular(5.435 * scale),
            ),
            padding: EdgeInsets.all(4.659 * scale),
            child: TextField(
              controller: controller,
              maxLines: null,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.212 * scale,
                color: textGray400,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.212 * scale,
                  color: textGray400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectPhotos(double scale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray100,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.153 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library,
                size: 6.212 * scale,
                color: const Color(0xFF364153),
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                'Project Photos',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF364153),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.659 * scale),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _pickImages,
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: Container(
                height: 69.882 * scale,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderGray200,
                    width: 0.776 * scale,
                  ),
                  borderRadius: BorderRadius.circular(5.435 * scale),
                ),
                padding: EdgeInsets.all(13.2 * scale),
                child: _selectedImages.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 18.635 * scale,
                            height: 18.635 * scale,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 9.318 * scale,
                              color: primaryBlue,
                            ),
                          ),
                          SizedBox(height: 3.106 * scale),
                          Text(
                            'Click to upload photos',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 6.212 * scale,
                              fontWeight: FontWeight.w400,
                              color: textGray900,
                            ),
                          ),
                          SizedBox(height: 1.553 * scale),
                          Text(
                            'PNG, JPG up to 10MB',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 6.212 * scale,
                              fontWeight: FontWeight.w400,
                              color: textGray600,
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4 * scale,
                          mainAxisSpacing: 4 * scale,
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4 * scale),
                                child: Image.file(
                                  _selectedImages[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 2 * scale,
                                right: 2 * scale,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2 * scale),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 8 * scale,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildSubcontractorsSection(double scale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray100,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.153 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                size: 6.212 * scale,
                color: const Color(0xFF364153),
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                'Subcontractors',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF364153),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.659 * scale),
          // List of added subcontractors (show only names when not editing)
          ...List.generate(_subcontractors.length, (index) {
            final name = _subcontractorNameControllers[index]?.text ?? '';
            final isNewlyAdded = _newlyAddedSubcontractorIndices.contains(index);
            // Check if any field in this form has focus
            final hasAnyFocus = 
                (_subcontractorNameFocusNodes[index]?.hasFocus ?? false) ||
                (_subcontractorCompanyFocusNodes[index]?.hasFocus ?? false) ||
                (_subcontractorEmailFocusNodes[index]?.hasFocus ?? false) ||
                (_subcontractorContactFocusNodes[index]?.hasFocus ?? false) ||
                (_subcontractorSpecialityFocusNodes[index]?.hasFocus ?? false);
            // Show form if: (name is empty AND it's newly added) OR any field has focus
            // Show name card if: name is not empty AND no field is focused (remove from newly added set)
            if ((name.isEmpty && isNewlyAdded) || hasAnyFocus) {
              // If name is filled and no focus, remove from newly added set
              if (name.isNotEmpty && !hasAnyFocus) {
                _newlyAddedSubcontractorIndices.remove(index);
              }
              return _buildSubcontractorForm(scale, index);
            } else {
              // Remove from newly added set when showing name card
              _newlyAddedSubcontractorIndices.remove(index);
              return _buildSubcontractorNameCard(scale, index, name);
            }
          }),
          SizedBox(height: 3.106 * scale),
          // Add Subcontractor Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  final newIndex = _subcontractors.length;
                  _subcontractors.add(Subcontractor());
                  // Mark as newly added
                  _newlyAddedSubcontractorIndices.add(newIndex);
                  // Unfocus all previous items
                  for (int i = 0; i < newIndex; i++) {
                    _subcontractorNameFocusNodes[i]?.unfocus();
                    _subcontractorCompanyFocusNodes[i]?.unfocus();
                    _subcontractorEmailFocusNodes[i]?.unfocus();
                    _subcontractorContactFocusNodes[i]?.unfocus();
                    _subcontractorSpecialityFocusNodes[i]?.unfocus();
                  }
                  // Auto-focus the name field after a short delay
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted && _subcontractorNameFocusNodes.containsKey(newIndex)) {
                      _subcontractorNameFocusNodes[newIndex]?.requestFocus();
                    }
                  });
                });
              },
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: Container(
                height: 17.082 * scale,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryBlue, primaryBlueDark],
                  ),
                  borderRadius: BorderRadius.circular(5.435 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.25),
                      blurRadius: 5.824 * scale,
                      offset: Offset(0, 1.553 * scale),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Add Subcontractor',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.435 * scale,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcontractorNameCard(double scale, int index, String name) {
    return Container(
      margin: EdgeInsets.only(bottom: 8 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue.withOpacity(0.1),
            primaryBlueDark.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3),
          width: 0.776 * scale,
        ),
        borderRadius: BorderRadius.circular(8 * scale),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.2),
            blurRadius: 8 * scale,
            offset: Offset(0, 3 * scale),
            spreadRadius: 1 * scale,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.153 * scale,
        vertical: 6.212 * scale,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 10.388 * scale,
                  height: 10.388 * scale,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 5.435 * scale,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4.659 * scale),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 6.212 * scale,
                      color: primaryBlueDark,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _subcontractorNameControllers[index]?.clear();
                      // Request focus to show form again
                      _subcontractorNameFocusNodes[index]?.requestFocus();
                    });
                  },
                  borderRadius: BorderRadius.circular(4 * scale),
                  child: Container(
                    padding: EdgeInsets.all(3.106 * scale),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 6.212 * scale,
                      color: primaryBlueDark,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.106 * scale),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _subcontractors.removeAt(index);
                      _subcontractorNameControllers[index]?.dispose();
                      _subcontractorCompanyControllers[index]?.dispose();
                      _subcontractorEmailControllers[index]?.dispose();
                      _subcontractorContactControllers[index]?.dispose();
                      _subcontractorSpecialityControllers[index]?.dispose();
                      _subcontractorNameControllers.remove(index);
                      _subcontractorCompanyControllers.remove(index);
                      _subcontractorEmailControllers.remove(index);
                      _subcontractorContactControllers.remove(index);
                      _subcontractorSpecialityControllers.remove(index);
                      _subcontractorNameFocusNodes[index]?.dispose();
                      _subcontractorCompanyFocusNodes[index]?.dispose();
                      _subcontractorEmailFocusNodes[index]?.dispose();
                      _subcontractorContactFocusNodes[index]?.dispose();
                      _subcontractorSpecialityFocusNodes[index]?.dispose();
                      _subcontractorNameFocusNodes.remove(index);
                      _subcontractorCompanyFocusNodes.remove(index);
                      _subcontractorEmailFocusNodes.remove(index);
                      _subcontractorContactFocusNodes.remove(index);
                      _subcontractorSpecialityFocusNodes.remove(index);
                    });
                  },
                  borderRadius: BorderRadius.circular(4 * scale),
                  child: Container(
                    padding: EdgeInsets.all(3.106 * scale),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 6.212 * scale,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubcontractorForm(double scale, int index) {
    if (!_subcontractorNameControllers.containsKey(index)) {
      _subcontractorNameControllers[index] = TextEditingController();
      _subcontractorCompanyControllers[index] = TextEditingController();
      _subcontractorEmailControllers[index] = TextEditingController();
      _subcontractorContactControllers[index] = TextEditingController();
      _subcontractorSpecialityControllers[index] = TextEditingController();
    }
    // Initialize focus nodes if not exists
    if (!_subcontractorNameFocusNodes.containsKey(index)) {
      _subcontractorNameFocusNodes[index] = FocusNode();
      _subcontractorNameFocusNodes[index]!.addListener(() {
        setState(() {}); // Rebuild when focus changes
      });
    }
    if (!_subcontractorCompanyFocusNodes.containsKey(index)) {
      _subcontractorCompanyFocusNodes[index] = FocusNode();
      _subcontractorCompanyFocusNodes[index]!.addListener(() {
        setState(() {});
      });
    }
    if (!_subcontractorEmailFocusNodes.containsKey(index)) {
      _subcontractorEmailFocusNodes[index] = FocusNode();
      _subcontractorEmailFocusNodes[index]!.addListener(() {
        setState(() {});
      });
    }
    if (!_subcontractorContactFocusNodes.containsKey(index)) {
      _subcontractorContactFocusNodes[index] = FocusNode();
      _subcontractorContactFocusNodes[index]!.addListener(() {
        setState(() {});
      });
    }
    if (!_subcontractorSpecialityFocusNodes.containsKey(index)) {
      _subcontractorSpecialityFocusNodes[index] = FocusNode();
      _subcontractorSpecialityFocusNodes[index]!.addListener(() {
        setState(() {});
      });
    }

    return Column(
      children: [
        if (index > 0) ...[
          SizedBox(height: 3.106 * scale),
          Divider(height: 1, color: borderGray200),
          SizedBox(height: 3.106 * scale),
        ],
        _buildSmallInputField(
          scale,
          controller: _subcontractorNameControllers[index]!,
          hint: 'Name',
          focusNode: _subcontractorNameFocusNodes[index],
        ),
        SizedBox(height: 3.106 * scale),
        _buildSmallInputField(
          scale,
          controller: _subcontractorCompanyControllers[index]!,
          hint: 'Company Name',
          focusNode: _subcontractorCompanyFocusNodes[index],
        ),
        SizedBox(height: 3.106 * scale),
        _buildSmallInputField(
          scale,
          controller: _subcontractorEmailControllers[index]!,
          hint: 'Email',
          focusNode: _subcontractorEmailFocusNodes[index],
        ),
        SizedBox(height: 3.106 * scale),
        _buildSmallInputField(
          scale,
          controller: _subcontractorContactControllers[index]!,
          hint: 'Contact Number',
          focusNode: _subcontractorContactFocusNodes[index],
        ),
        SizedBox(height: 3.106 * scale),
        _buildSmallInputField(
          scale,
          controller: _subcontractorSpecialityControllers[index]!,
          hint: 'Speciality',
          focusNode: _subcontractorSpecialityFocusNodes[index],
        ),
        if (index > 0) ...[
          SizedBox(height: 3.106 * scale),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _subcontractors.removeAt(index);
                  _subcontractorNameControllers[index]?.dispose();
                  _subcontractorCompanyControllers[index]?.dispose();
                  _subcontractorEmailControllers[index]?.dispose();
                  _subcontractorContactControllers[index]?.dispose();
                  _subcontractorSpecialityControllers[index]?.dispose();
                  _subcontractorNameControllers.remove(index);
                  _subcontractorCompanyControllers.remove(index);
                  _subcontractorEmailControllers.remove(index);
                  _subcontractorContactControllers.remove(index);
                  _subcontractorSpecialityControllers.remove(index);
                  _subcontractorNameFocusNodes[index]?.dispose();
                  _subcontractorCompanyFocusNodes[index]?.dispose();
                  _subcontractorEmailFocusNodes[index]?.dispose();
                  _subcontractorContactFocusNodes[index]?.dispose();
                  _subcontractorSpecialityFocusNodes[index]?.dispose();
                  _subcontractorNameFocusNodes.remove(index);
                  _subcontractorCompanyFocusNodes.remove(index);
                  _subcontractorEmailFocusNodes.remove(index);
                  _subcontractorContactFocusNodes.remove(index);
                  _subcontractorSpecialityFocusNodes.remove(index);
                  _newlyAddedSubcontractorIndices.remove(index);
                  // Update indices for items after the removed one
                  final indicesToUpdate = _newlyAddedSubcontractorIndices.where((i) => i > index).toList();
                  _newlyAddedSubcontractorIndices.removeAll(indicesToUpdate);
                  for (var i in indicesToUpdate) {
                    _newlyAddedSubcontractorIndices.add(i - 1);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(4 * scale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 12 * scale,
                      color: Colors.red,
                    ),
                    SizedBox(width: 4 * scale),
                    Text(
                      'Remove',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 5.435 * scale,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSmallInputField(
    double scale, {
    required TextEditingController controller,
    required String hint,
    FocusNode? focusNode,
  }) {
    return Container(
      height: 17.082 * scale,
      decoration: BoxDecoration(
        color: bgGray100,
        border: Border.all(
          color: borderGray200,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(5.435 * scale),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 4.659 * scale,
        vertical: 1.553 * scale,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        onChanged: (value) {
          setState(() {}); // Trigger rebuild to update UI
        },
        style: TextStyle(
          fontFamily: 'Arimo',
          fontSize: 6.212 * scale,
          color: textGray400,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 6.212 * scale,
            color: textGray400,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildTasksSection(double scale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray100,
          width: 0.388 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.153 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                size: 6.212 * scale,
                color: const Color(0xFF364153),
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                'Tasks',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF364153),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.659 * scale),
          // List of tasks (show only names when not editing)
          ...List.generate(_tasks.length, (index) {
            final name = _taskNameControllers[index]?.text ?? '';
            final isNewlyAdded = _newlyAddedTaskIndices.contains(index);
            // Check if any field in this form has focus
            final hasAnyFocus = 
                (_taskNameFocusNodes[index]?.hasFocus ?? false) ||
                (_taskDescriptionFocusNodes[index]?.hasFocus ?? false) ||
                (_taskCostFocusNodes[index]?.hasFocus ?? false);
            // Show form if: name is empty OR any field has focus OR it's newly added
            // Show name card only if: name is not empty AND no field is focused AND it's not newly added
            // Keep newly added items open until user explicitly clicks away
            if (name.isEmpty || hasAnyFocus || isNewlyAdded) {
              return _buildTaskForm(scale, index);
            } else {
              // Remove from newly added set when showing name card
              _newlyAddedTaskIndices.remove(index);
              return _buildTaskNameCard(scale, index, name);
            }
          }),
          SizedBox(height: 3.106 * scale),
          // Add Task Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  final newIndex = _tasks.length;
                  _tasks.add(Task());
                  // Mark as newly added
                  _newlyAddedTaskIndices.add(newIndex);
                  // Unfocus all previous items
                  for (int i = 0; i < newIndex; i++) {
                    _taskNameFocusNodes[i]?.unfocus();
                    _taskDescriptionFocusNodes[i]?.unfocus();
                    _taskCostFocusNodes[i]?.unfocus();
                  }
                  // Auto-focus the name field after a short delay
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted && _taskNameFocusNodes.containsKey(newIndex)) {
                      _taskNameFocusNodes[newIndex]?.requestFocus();
                    }
                  });
                });
              },
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: Container(
                height: 18.635 * scale,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryBlue, primaryBlueDark],
                  ),
                  borderRadius: BorderRadius.circular(5.435 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.25),
                      blurRadius: 5.824 * scale,
                      offset: Offset(0, 1.553 * scale),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.435 * scale,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskNameCard(double scale, int index, String name) {
    return Container(
      margin: EdgeInsets.only(bottom: 8 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue.withOpacity(0.1),
            primaryBlueDark.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3),
          width: 0.776 * scale,
        ),
        borderRadius: BorderRadius.circular(8 * scale),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.2),
            blurRadius: 8 * scale,
            offset: Offset(0, 3 * scale),
            spreadRadius: 1 * scale,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.153 * scale,
        vertical: 6.212 * scale,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 10.388 * scale,
                  height: 10.388 * scale,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 5.435 * scale,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4.659 * scale),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 6.212 * scale,
                      color: primaryBlueDark,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _taskNameControllers[index]?.clear();
                      // Request focus to show form again
                      _taskNameFocusNodes[index]?.requestFocus();
                    });
                  },
                  borderRadius: BorderRadius.circular(4 * scale),
                  child: Container(
                    padding: EdgeInsets.all(3.106 * scale),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 6.212 * scale,
                      color: primaryBlueDark,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.106 * scale),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _tasks.removeAt(index);
                      _taskNameControllers[index]?.dispose();
                      _taskDescriptionControllers[index]?.dispose();
                      _taskCostControllers[index]?.dispose();
                      _taskNameControllers.remove(index);
                      _taskDescriptionControllers.remove(index);
                      _taskCostControllers.remove(index);
                      _taskNameFocusNodes[index]?.dispose();
                      _taskDescriptionFocusNodes[index]?.dispose();
                      _taskCostFocusNodes[index]?.dispose();
                      _taskNameFocusNodes.remove(index);
                      _taskDescriptionFocusNodes.remove(index);
                      _taskCostFocusNodes.remove(index);
                      _newlyAddedTaskIndices.remove(index);
                      // Update indices for items after the removed one
                      final indicesToUpdate = _newlyAddedTaskIndices.where((i) => i > index).toList();
                      _newlyAddedTaskIndices.removeAll(indicesToUpdate);
                      for (var i in indicesToUpdate) {
                        _newlyAddedTaskIndices.add(i - 1);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(4 * scale),
                  child: Container(
                    padding: EdgeInsets.all(3.106 * scale),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 6.212 * scale,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskForm(double scale, int index) {
    if (!_taskNameControllers.containsKey(index)) {
      _taskNameControllers[index] = TextEditingController();
      _taskDescriptionControllers[index] = TextEditingController();
      _taskCostControllers[index] = TextEditingController();
    }
    // Initialize focus nodes if not exists
    if (!_taskNameFocusNodes.containsKey(index)) {
      _taskNameFocusNodes[index] = FocusNode();
      _taskNameFocusNodes[index]!.addListener(() {
        setState(() {}); // Rebuild when focus changes
      });
    }
    if (!_taskDescriptionFocusNodes.containsKey(index)) {
      _taskDescriptionFocusNodes[index] = FocusNode();
      _taskDescriptionFocusNodes[index]!.addListener(() {
        setState(() {});
      });
    }
    if (!_taskCostFocusNodes.containsKey(index)) {
      _taskCostFocusNodes[index] = FocusNode();
      _taskCostFocusNodes[index]!.addListener(() {
        setState(() {});
      });
    }

    final task = _tasks[index];

    return Column(
      children: [
        if (index > 0) ...[
          SizedBox(height: 3.106 * scale),
          Divider(height: 1, color: borderGray200),
          SizedBox(height: 3.106 * scale),
        ],
        _buildSmallInputField(
          scale,
          controller: _taskNameControllers[index]!,
          hint: 'Task Name',
          focusNode: _taskNameFocusNodes[index],
        ),
        SizedBox(height: 3.106 * scale),
        Container(
          height: 38.824 * scale,
          decoration: BoxDecoration(
            color: bgGray100,
            border: Border.all(
              color: borderGray200,
              width: 0.388 * scale,
            ),
            borderRadius: BorderRadius.circular(5.435 * scale),
          ),
          padding: EdgeInsets.all(4.659 * scale),
          child: TextField(
            controller: _taskDescriptionControllers[index],
            focusNode: _taskDescriptionFocusNodes[index],
            maxLines: null,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 6.212 * scale,
              color: textGray400,
            ),
            decoration: InputDecoration(
              hintText: 'Description',
              hintStyle: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.212 * scale,
                color: textGray400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        SizedBox(height: 3.106 * scale),
        _buildDropdownField(scale, 'Trade', task.trade, (value) {
          setState(() {
            task.trade = value ?? '';
          });
        }),
        SizedBox(height: 3.106 * scale),
        // Start Date
        _buildDateField(
          scale,
          icon: Icons.calendar_today,
          label: 'Start Date',
          date: task.startDate,
          onTap: () => _selectDate(context, scale, taskIndex: index, isStartDate: true),
        ),
        SizedBox(height: 3.106 * scale),
        // End Date
        _buildDateField(
          scale,
          icon: Icons.calendar_today,
          label: 'End Date',
          date: task.endDate,
          onTap: () => _selectDate(context, scale, taskIndex: index, isStartDate: false),
        ),
        SizedBox(height: 3.106 * scale),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(scale, 'Status', task.status, (value) {
                setState(() {
                  task.status = value ?? '';
                });
              }),
            ),
            SizedBox(width: 3.106 * scale),
            Expanded(
              child: _buildDropdownField(scale, 'Priority', task.priority, (value) {
                setState(() {
                  task.priority = value ?? '';
                });
              }),
            ),
          ],
        ),
        SizedBox(height: 3.106 * scale),
        _buildSmallInputField(
          scale,
          controller: _taskCostControllers[index]!,
          hint: 'Cost',
          focusNode: _taskCostFocusNodes[index],
        ),
        SizedBox(height: 3.106 * scale),
        // Assigned Subcontractors
        _buildAssignedSubcontractors(scale, index),
        if (index > 0) ...[
          SizedBox(height: 3.106 * scale),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _tasks.removeAt(index);
                  _taskNameControllers[index]?.dispose();
                  _taskDescriptionControllers[index]?.dispose();
                  _taskCostControllers[index]?.dispose();
                  _taskNameControllers.remove(index);
                  _taskDescriptionControllers.remove(index);
                  _taskCostControllers.remove(index);
                  _taskNameFocusNodes[index]?.dispose();
                  _taskDescriptionFocusNodes[index]?.dispose();
                  _taskCostFocusNodes[index]?.dispose();
                  _taskNameFocusNodes.remove(index);
                  _taskDescriptionFocusNodes.remove(index);
                  _taskCostFocusNodes.remove(index);
                  _newlyAddedTaskIndices.remove(index);
                  // Update indices for items after the removed one
                  final indicesToUpdate = _newlyAddedTaskIndices.where((i) => i > index).toList();
                  _newlyAddedTaskIndices.removeAll(indicesToUpdate);
                  for (var i in indicesToUpdate) {
                    _newlyAddedTaskIndices.add(i - 1);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(4 * scale),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 12 * scale,
                      color: Colors.red,
                    ),
                    SizedBox(width: 4 * scale),
                    Text(
                      'Remove Task',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 5.435 * scale,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField(
    double scale,
    String label,
    String value,
    Function(String?) onChanged,
  ) {
    final options = label == 'Trade'
        ? ['Foundation', 'Framing', 'MEP', 'Finishing', 'Electrical', 'Plumbing']
        : label == 'Status'
            ? ['Not Started', 'In Progress', 'Completed', 'On Hold']
            : ['Low', 'Medium', 'High', 'Urgent'];

    // Get icon based on label
    IconData iconData = Icons.work_outline;
    if (label == 'Status') {
      iconData = Icons.flag_outlined;
    } else if (label == 'Priority') {
      iconData = Icons.priority_high;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: value.isEmpty ? borderGray200 : primaryBlue.withOpacity(0.3),
          width: 0.776 * scale,
        ),
        borderRadius: BorderRadius.circular(6.212 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.212 * scale, vertical: 0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          isExpanded: true,
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 6.212 * scale,
                color: textGray600,
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  color: textGray600,
                ),
              ),
            ],
          ),
          selectedItemBuilder: (BuildContext context) {
            return options.map((String option) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      size: 5.435 * scale,
                      color: primaryBlueDark,
                    ),
                    SizedBox(width: 3.106 * scale),
                    Flexible(
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 5.435 * scale,
                          color: primaryBlueDark,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 7.765 * scale,
            color: value.isEmpty ? textGray600 : primaryBlueDark,
          ),
          iconSize: 7.765 * scale,
          dropdownColor: Colors.white,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.435 * scale,
            color: primaryBlueDark,
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3.106 * scale),
                child: Row(
                  children: [
                    Icon(
                      iconData,
                      size: 5.435 * scale,
                      color: textGray600,
                    ),
                    SizedBox(width: 4.659 * scale),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 5.435 * scale,
                          color: textGray400,
                        ),
                      ),
                    ),
                    if (value == option)
                      Icon(
                        Icons.check_circle,
                        size: 5.435 * scale,
                        color: primaryBlue,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            // Only call onChanged if a value is actually selected (not null)
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAssignedSubcontractors(double scale, int taskIndex) {
    final task = _tasks[taskIndex];
    final availableSubcontractors = _subcontractors
        .asMap()
        .entries
        .where((entry) =>
            _subcontractorNameControllers[entry.key]?.text.isNotEmpty ?? false)
        .map((entry) => _subcontractorNameControllers[entry.key]!.text)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.people_outline,
              size: 6.212 * scale,
              color: const Color(0xFF364153),
            ),
            SizedBox(width: 3.106 * scale),
            Text(
              'Assigned Subcontractors',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 5.435 * scale,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF364153),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.106 * scale),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderGray200,
              width: 0.388 * scale,
            ),
            borderRadius: BorderRadius.circular(5.435 * scale),
          ),
          padding: EdgeInsets.all(6.6 * scale),
          child: availableSubcontractors.isEmpty
              ? Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 18.635 * scale,
                      color: textGray600,
                    ),
                    SizedBox(height: 3.106 * scale),
                    Text(
                      'No subcontractors added yet',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 5.435 * scale,
                        color: textGray600,
                      ),
                    ),
                    SizedBox(height: 1.553 * scale),
                    Text(
                      'Add subcontractors above to assign them to this task',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 4.659 * scale,
                        color: const Color(0xFF99A1AF),
                      ),
                    ),
                  ],
                )
              : Wrap(
                  spacing: 3.106 * scale,
                  runSpacing: 3.106 * scale,
                  children: availableSubcontractors.map((name) {
                    final isSelected = task.assignedSubcontractors.contains(name);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            task.assignedSubcontractors.remove(name);
                          } else {
                            task.assignedSubcontractors.add(name);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.659 * scale,
                          vertical: 2.329 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryBlue : bgGray100,
                          border: Border.all(
                            color: isSelected ? primaryBlue : borderGray200,
                            width: 0.388 * scale,
                          ),
                          borderRadius: BorderRadius.circular(3.106 * scale),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              Icon(
                                Icons.check,
                                size: 8 * scale,
                                color: Colors.white,
                              ),
                            if (isSelected) SizedBox(width: 2 * scale),
                            Text(
                              name,
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 5.435 * scale,
                                color: isSelected ? Colors.white : textGray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    double scale, {
    int? taskIndex,
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textGray900,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (taskIndex != null) {
          if (isStartDate) {
            _tasks[taskIndex].startDate = picked;
          } else {
            _tasks[taskIndex].endDate = picked;
          }
        } else {
          _startDate = picked;
        }
      });
    }
  }

  Widget _buildCreateButton(double scale) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Save project
          _showSuccessAnimation(scale);
        },
        borderRadius: BorderRadius.circular(5.435 * scale),
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.2),
        child: Container(
          width: double.infinity,
          height: 18.635 * scale,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryBlue, primaryBlueDark],
            ),
            borderRadius: BorderRadius.circular(5.435 * scale),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.25),
                blurRadius: 5.824 * scale,
                offset: Offset(0, 1.553 * scale),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Create Project',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 5.435 * scale,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessAnimation(double scale) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: 35 * scale,
            vertical: 60 * scale,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 120 * scale,
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              padding: EdgeInsets.all(12 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.984 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 25 * scale,
                    spreadRadius: 5 * scale,
                  ),
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.1),
                    blurRadius: 15 * scale,
                    spreadRadius: 2 * scale,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Beautiful animated success icon with theme colors
                  _buildAnimatedSuccessIcon(scale),
                  SizedBox(height: 10 * scale),
                  Text(
                    'Project Created!',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 7.091 * scale,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 5 * scale),
                  Text(
                    'Your project has been\nsuccessfully created',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.008 * scale,
                      fontWeight: FontWeight.w400,
                      color: textGray,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // Close dialog
                        // Navigate to Projects tab
                        Navigator.of(context).pushAndRemoveUntil(
                          _NoAnimationPageRoute(
                            builder: (context) => const ProjectsPage(),
                          ),
                          (route) => false,
                        );
                      },
                      borderRadius: BorderRadius.circular(5.508 * scale),
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.2),
                      child: Ink(
                        width: double.infinity,
                        height: 18.885 * scale,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [primaryBlue, primaryBlueDark],
                          ),
                          borderRadius: BorderRadius.circular(5.508 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.3),
                              offset: Offset(0, 3.934 * scale),
                              blurRadius: 5.902 * scale,
                              spreadRadius: -1.18 * scale,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 5.508 * scale,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSuccessIcon(double scale) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // Clamp opacity values to prevent assertion errors
        final outerOpacity = (0.05 * (1 - value)).clamp(0.0, 1.0);
        final middleOpacity = (0.08 * (1 - value)).clamp(0.0, 1.0);
        final innerOpacity = (0.12 * (1 - value)).clamp(0.0, 1.0);
        
        // Rotation animation for more dynamic effect
        final rotation = value * 360;
        
        return SizedBox(
          width: 65 * scale,
          height: 65 * scale,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Outer pulsing circle - largest with rotation
              Transform.rotate(
                angle: rotation * 0.5 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.25).clamp(0.0, 1.3),
                  child: Container(
                    width: 65 * scale,
                    height: 65 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withOpacity(outerOpacity),
                    ),
                  ),
                ),
              ),
              // Middle pulsing circle with rotation
              Transform.rotate(
                angle: -rotation * 0.3 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.15).clamp(0.0, 1.2),
                  child: Container(
                    width: 55 * scale,
                    height: 55 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withOpacity(middleOpacity),
                    ),
                  ),
                ),
              ),
              // Inner circle with rotation
              Transform.rotate(
                angle: rotation * 0.2 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.08).clamp(0.0, 1.1),
                  child: Container(
                    width: 45 * scale,
                    height: 45 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withOpacity(innerOpacity),
                    ),
                  ),
                ),
              ),
              // Main circle with check - theme blue gradient (no rotation, just scale)
              Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: Container(
                  width: 38 * scale,
                  height: 38 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryBlue, primaryBlueDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.6),
                        blurRadius: 12 * scale,
                        spreadRadius: 5 * scale,
                      ),
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.4),
                        blurRadius: 8 * scale,
                        spreadRadius: 2 * scale,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    size: 24 * scale,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

