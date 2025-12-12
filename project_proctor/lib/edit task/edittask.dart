import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/project_service.dart';

class EditTask extends StatefulWidget {
  final Task? task;
  final String projectId;

  const EditTask({
    super.key,
    this.task,
    required this.projectId,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  
  String? _selectedTrade;
  String? _selectedStatus;
  String? _selectedPriority;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedTeamMembers = [];
  Task? _savedTask; // Store saved task to return when closing

  final ProjectService _projectService = MockProjectService();

  // Color constants
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF101828);
  static const Color textGray = Color(0xFF6A7282);
  static const Color bgGray200 = Color(0xFFE5E7EB);
  static const Color bgInput = Color(0xFFF3F3F5);
  static const Color primaryBlue = Color(0xFF2779F5);
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blueBorder = Color(0xFF2B7FFF);
  static const Color blueText = Color(0xFF1C398E);
  static const Color blueTextLight = Color(0xFF155DFC);
  static const Color blueIcon = Color(0xFF1447E6);

  final List<String> _trades = ['Concrete', 'Steel', 'Electrical', 'HVAC', 'Plumbing', 'Framing', 'Finishes'];
  final List<String> _statuses = ['not started', 'in progress', 'completed'];
  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];
  
  final List<Map<String, String>> _teamMembers = [
    {'id': 'user_001', 'name': 'Maria Garcia', 'company': 'Garcia Construction'},
    {'id': 'user_002', 'name': 'John Martinez', 'company': 'Martinez Electrical Co.'},
    {'id': 'user_003', 'name': 'Robert Johnson', 'company': 'Johnson HVAC Systems'},
    {'id': 'user_004', 'name': 'Lisa Chen', 'company': 'Chen Plumbing Services'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _descriptionController.text = 'Details';
      _selectedTrade = widget.task!.trade;
      _selectedStatus = widget.task!.status;
      _selectedPriority = widget.task!.priority;
      _costController.text = '0';
      if (widget.task!.assignedTo != null) {
        _selectedTeamMembers = [widget.task!.assignedTo!];
      }
      
      // Parse dates from strings like "Sep 15" or "15/9/2024"
      try {
        final startParts = widget.task!.startDate.split(' ');
        if (startParts.length >= 2) {
          final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          final monthIndex = monthNames.indexOf(startParts[0]);
          if (monthIndex != -1) {
            _startDate = DateTime(2024, monthIndex + 1, int.parse(startParts[1]));
          }
        }
      } catch (e) {
        // Ignore date parsing errors
      }
      
      try {
        final endParts = widget.task!.endDate.split(' ');
        if (endParts.length >= 2) {
          final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          final monthIndex = monthNames.indexOf(endParts[0]);
          if (monthIndex != -1) {
            _endDate = DateTime(2024, monthIndex + 1, int.parse(endParts[1]));
          }
        }
      } catch (e) {
        // Ignore date parsing errors
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: white,
              surface: white,
              onSurface: textDark,
            ),
            dialogBackgroundColor: white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${monthNames[date.month - 1]} ${date.day}';
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTrade == null || _selectedStatus == null || _selectedPriority == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      final selectedMember = _selectedTeamMembers.isNotEmpty
          ? _teamMembers.firstWhere(
              (m) => m['id'] == _selectedTeamMembers.first,
              orElse: () => _teamMembers[0],
            )
          : _teamMembers[0];

      final task = Task(
        id: widget.task?.id ?? '',
        name: _nameController.text,
        trade: _selectedTrade!,
        status: _selectedStatus!,
        priority: _selectedPriority!,
        progress: widget.task?.progress ?? 0,
        startDate: _startDate != null ? _formatDate(_startDate) : '',
        endDate: _endDate != null ? _formatDate(_endDate) : '',
        assignedTo: _selectedTeamMembers.isNotEmpty ? _selectedTeamMembers.first : null,
        assignedToName: selectedMember['name'],
      );

      try {
        Task savedTask;
        if (widget.task != null) {
          savedTask = await _projectService.updateTask(task.id, task);
        } else {
          savedTask = await _projectService.createTask(widget.projectId, task);
        }

        if (mounted) {
          _savedTask = savedTask;
          // Show success animation instead of directly popping
          final scale = MediaQuery.of(context).size.width / 165.0;
          _showSuccessAnimation(scale);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving task: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final baseWidth = 161.137;
    final scale = (screenWidth / baseWidth).clamp(0.8, 2.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10 * scale),
      child: Container(
        width: 160 * scale,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(3.75 * scale),
          border: Border.all(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            width: 0.375 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 3.75 * scale),
              blurRadius: 5.625 * scale,
              spreadRadius: -1.125 * scale,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 1.5 * scale),
              blurRadius: 2.25 * scale,
              spreadRadius: -1.5 * scale,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(12 * scale),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.task != null ? 'Edit Task' : 'Add Task',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 7.5 * scale,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 6.0 * scale,
                          height: 6.0 * scale,
                          child: Icon(
                            Icons.close,
                            size: 6.0 * scale,
                            color: textDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Form Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 3 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(scale, 'Task Name', _nameController),
                      SizedBox(height: 5.0 * scale),
                      _buildTextArea(scale, 'Description', _descriptionController),
                      SizedBox(height: 5.0 * scale),
                      _buildDropdownField(scale, 'Trade', _selectedTrade, _trades, (value) {
                        setState(() => _selectedTrade = value);
                      }),
                      SizedBox(height: 5.0 * scale),
                      // Status and Priority side by side
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(scale, 'Status', _selectedStatus, _statuses, (value) {
                              setState(() => _selectedStatus = value);
                            }),
                          ),
                          SizedBox(width: 5.0 * scale),
                          Expanded(
                            child: _buildDropdownField(scale, 'Priority', _selectedPriority, _priorities, (value) {
                              setState(() => _selectedPriority = value);
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0 * scale),
                      // Start and End dates side by side
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(scale, 'Start', _startDate, true),
                          ),
                          SizedBox(width: 5.0 * scale),
                          Expanded(
                            child: _buildDateField(scale, 'End', _endDate, false),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0 * scale),
                      _buildTextField(scale, 'Cost', _costController, keyboardType: TextInputType.number, isCost: true),
                      SizedBox(height: 5.0 * scale),
                      _buildTeamAssignment(scale),
                      SizedBox(height: 4.0 * scale),
                      // Cancel and Update buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildCancelButton(scale),
                          ),
                          SizedBox(width: 5.0 * scale),
                          Expanded(
                            child: _buildUpdateButton(scale),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.0 * scale),
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

  Widget _buildTextField(double scale, String label, TextEditingController controller, {TextInputType? keyboardType, bool isCost = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.5 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
        ),
        SizedBox(height: 2.5 * scale),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 6.5 * scale,
            color: Color(0xFF717182),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.75 * scale),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.75 * scale),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.75 * scale),
              borderSide: BorderSide(color: primaryBlue, width: 0.375 * scale),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 6.0 * scale,
              vertical: isCost ? 2.5 * scale : 2.0 * scale,
            ),
            constraints: isCost ? BoxConstraints(minHeight: 18.0 * scale) : null,
            hintText: label == 'Cost' ? '0' : 'Enter $label',
            hintStyle: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 6.5 * scale,
              color: Color(0xFF717182),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(double scale, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.5 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
        ),
        SizedBox(height: 2.5 * scale),
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: bgInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.75 * scale),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.75 * scale),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.75 * scale),
              borderSide: BorderSide(color: primaryBlue, width: 0.375 * scale),
            ),
            contentPadding: EdgeInsets.all(6.0 * scale),
            hintText: 'Details',
            hintStyle: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 6.5 * scale,
              color: Color(0xFF717182),
            ),
          ),
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 6.5 * scale,
            color: Color(0xFF717182),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(double scale, String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.5 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
        ),
        SizedBox(height: 2.5 * scale),
        Container(
          height: 18.0 * scale,
          decoration: BoxDecoration(
            color: bgInput,
            borderRadius: BorderRadius.circular(3.75 * scale),
            border: Border.all(
              color: Colors.transparent,
              width: 0.375 * scale,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0 * scale),
                child: Text(
                  'Select $label',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.5 * scale,
                    color: Color(0xFF717182),
                  ),
                ),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0 * scale),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 6.5 * scale,
                        color: textDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.5 * scale,
                color: textDark,
              ),
              icon: Padding(
                padding: EdgeInsets.only(right: 6.0 * scale),
                child: Icon(Icons.arrow_drop_down, size: 7.0 * scale, color: textGray),
              ),
              dropdownColor: white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(double scale, String label, DateTime? date, bool isStartDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.5 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
        ),
        SizedBox(height: 2.5 * scale),
        GestureDetector(
          onTap: () => _selectDate(context, isStartDate),
          child: Container(
            height: 18.0 * scale,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(3.75 * scale),
              border: Border.all(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 0.375 * scale,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 6.0 * scale),
                Icon(
                  Icons.calendar_today,
                  size: 7.0 * scale,
                  color: textDark,
                ),
                SizedBox(width: 6.0 * scale),
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date) : '',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.5 * scale,
                      color: textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamAssignment(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assign Team',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.5 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
        ),
        SizedBox(height: 3.0 * scale),
        // Team member cards
        Container(
          constraints: BoxConstraints(maxHeight: 48.0 * scale),
          child: SingleChildScrollView(
            child: Column(
              children: _teamMembers.map((member) {
                final isSelected = _selectedTeamMembers.contains(member['id']);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTeamMembers.remove(member['id']);
                      } else {
                        _selectedTeamMembers.add(member['id']!);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 3.0 * scale),
                    padding: EdgeInsets.all(4.5 * scale),
                    decoration: BoxDecoration(
                      color: isSelected ? blue50 : white,
                      border: Border.all(
                        color: isSelected ? blueBorder : bgGray200,
                        width: 0.375 * scale,
                      ),
                      borderRadius: BorderRadius.circular(3.75 * scale),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 11.0 * scale,
                          height: 11.0 * scale,
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFF155DFC) : bgGray200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 5.5 * scale,
                              color: white,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.0 * scale),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                member['name']!,
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 5.5 * scale,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected ? blueText : textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                member['company']!,
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 4.5 * scale,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected ? blueTextLight : textGray,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Selected count indicator
        if (_selectedTeamMembers.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 3.0 * scale),
            padding: EdgeInsets.symmetric(horizontal: 4.5 * scale, vertical: 0.5 * scale),
            decoration: BoxDecoration(
              color: blue50,
              border: Border.all(
                color: Color(0xFFBEDBFF),
                width: 0.375 * scale,
              ),
              borderRadius: BorderRadius.circular(3.75 * scale),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people,
                  size: 5.5 * scale,
                  color: blueIcon,
                ),
                SizedBox(width: 2.0 * scale),
                Text(
                  '${_selectedTeamMembers.length} selected',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 5.5 * scale,
                    fontWeight: FontWeight.w400,
                    color: blueIcon,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCancelButton(double scale) {
    return Container(
      height: 15.0 * scale,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(3.75 * scale),
        border: Border.all(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          width: 0.375 * scale,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(3.75 * scale),
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.5 * scale,
                fontWeight: FontWeight.w400,
                color: textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(double scale) {
    return Container(
      height: 15.0 * scale,
      decoration: BoxDecoration(
        color: Color(0xFF155DFC),
        borderRadius: BorderRadius.circular(3.75 * scale),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveTask,
          borderRadius: BorderRadius.circular(3.75 * scale),
          child: Center(
            child: Text(
              widget.task != null ? 'Update' : 'Add',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.5 * scale,
                fontWeight: FontWeight.w400,
                color: white,
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
                    widget.task != null ? 'Task Updated!' : 'Task Added!',
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
                    widget.task != null
                        ? 'The task has been\nsuccessfully updated'
                        : 'The new task has been\nsuccessfully added to your project',
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
                        Navigator.of(context).pop(); // Close success dialog
                        // Close EditTask dialog and return saved task (stays on task page)
                        Navigator.of(context).pop(_savedTask);
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
                            colors: [primaryBlue, blueIcon],
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
                      colors: [primaryBlue, blueIcon],
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
