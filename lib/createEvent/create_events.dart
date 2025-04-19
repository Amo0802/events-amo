// Create Event Page
import 'package:flutter/material.dart';

class CreateEventPage extends StatelessWidget {
  final bool isOfficial;
  
  CreateEventPage({required this.isOfficial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          isOfficial ? "Create Official Event" : "Create Community Event",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePicker(context),
            SizedBox(height: 20),
            _buildTextField(context, "Event Title", "Enter event title"),
            SizedBox(height: 20),
            _buildTextField(context, "Location", "Enter event location"),
            SizedBox(height: 20),
            _buildDateTimePicker(context),
            SizedBox(height: 20),
            _buildCategoryPicker(context),
            SizedBox(height: 20),
            _buildTextField(context, "Description", "Enter event description", maxLines: 5),
            SizedBox(height: 30),
            _buildSubmitButton(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 10),
          Text(
            "Upload Event Image",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            fillColor: Colors.white.withOpacity(0.07),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date & Time",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Select Date",
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Select Time",
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.category_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                "Select Category",
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // Submit event
          Navigator.pop(context);
        },
        child: Text(
          "Create Event",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isOfficial 
              ? Theme.of(context).colorScheme.primary 
              : Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
