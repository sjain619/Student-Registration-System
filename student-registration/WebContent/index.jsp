<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        .navbar {
            overflow: hidden;
            background-color: #333;
            font-family: Arial, Helvetica, sans-serif;
        }

        .navbar a {
            float: left;
            font-size: 16px;
            color: white;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
        }

        .dropdown {
            float: left;
            overflow: hidden;
        }

        .dropdown .dropbtn {
            cursor: pointer;
            font-size: 16px;
            border: none;
            outline: none;
            color: white;
            padding: 14px 16px;
            background-color: inherit;
            font-family: inherit;
            margin: 0;
        }

        .navbar a:hover, .dropdown:hover .dropbtn, .dropbtn:focus {
            background-color: green;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }

        .dropdown-content a {
            float: none;
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
        }

        .dropdown-content a:hover {
            background-color: #ddd;
        }

        .show {
            display: block;
        }
        .hide {
            display: none;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="dropdown">
        <button class="dropbtn" onclick="myFunction()">Menu
            <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-content" id="myDropdown">
            <a href="#" onclick="showForm('showTableRecs')" >Show Table Records</a>
            <a href="#" onclick="showForm('classTaDetails')" >Class TA Details</a>
            <a href="#" onclick="showForm('showPrerequisites')" >Show Prerequisites</a>
            <a href="#" onclick="showForm('dropStudent')" >Drop Student from Class</a>
            <a href="#" onclick="showForm('studentEnrollment')" >Student Enrollment</a>
            <a href="#" onclick="showForm('deleteStudent')" >Delete Student</a>
        </div>
    </div>
</div>
</br>
</br>
<form class="forms hide" id="showTableRecsForm" >
	<h3>Show Table Records</h3></br>
    <div>
    	<a href="app?display=students" target="_blank">Display Students</a></br>
        <a href="app?display=tas" target="_blank">Display TAs</a></br>
        <a href="app?display=courses" target="_blank">Display Courses</a></br>
        <a href="app?display=prerequisites" target="_blank">Display Prerequisites</a></br>
        <a href="app?display=classes" target="_blank">Display Classes</a></br>
        <a href="app?display=enrollments" target="_blank">Display Enrollments</a></br>
        <a href="app?display=logs" target="_blank">Display Logs</a></br>
    </div>
</form>

<form class="forms hide" id="classTaDetailsForm" action="app" method="GET" target="_blank">
	<h3>Class TA Details</h3></br>
    <label for="classId">Class ID</label>
    <input type="text" id="classId" name="classId">
    <button type="submit">Submit</button>
</form>

<form class="forms hide" id="showPrerequisitesForm" action="app" method="GET" target="_blank">
	<h3>Show Prerequisites</h3></br>
    <label for="departmentCode">Department Code</label>
    <input type="text" id="departmentCode" name="departmentCode">
    <label for="course">Course</label>
    <input type="number" id="course" name="course">
    <button type="submit">Submit</button>
</form>

<form class="forms hide" id="dropStudentForm" action="app" method="GET" target="_blank">
	<h3>Drop Student From Class</h3></br>
    <label for="bHashdropStudentForm">B#</label>
    <input type="text" id="bHashdropStudentForm" name="bHashdropStudentForm">
    <label for="classTasForm">Class</label>
    <input type="text" id="classTasForm" name="classTasForm">
    <button type="submit">Submit</button>
</form>

<form class="forms hide" id="studentEnrollmentForm" action="app" method="POST" target="_blank">
	<h3>Student Enrollment</h3></br>
    <label for="bHashstudentEnrollmentForm">B#</label>
    <input type="text" id="bHashstudentEnrollmentForm" name="bHashstudentEnrollmentForm">
    <label for="classClassesForm">Class</label>
    <input type="text" id="classClassesForm" name="classClassesForm">
    <button type="submit">Submit</button>
</form>

<form class="forms hide" id="deleteStudentForm" action="app" method="POST" target="_blank">
	<h3>Delete Student</h3></br>
    <label for="bHashdeleteStudentForm">B#</label>
    <input type="text" id="bHashdeleteStudentForm" name="bHashdeleteStudentForm">
    <button type="submit">Submit</button>
</form>


<script>
    /* When the user clicks on the button,
    toggle between hiding and showing the dropdown content */
    function myFunction() {
        document.getElementById("myDropdown").classList.toggle("show");
    }

    // Close the dropdown if the user clicks outside of it
    window.onclick = function(e) {
        if (!e.target.matches('.dropbtn')) {
            var myDropdown = document.getElementById("myDropdown");
            if (myDropdown.classList.contains('show')) {
                myDropdown.classList.remove('show');
            }
        }
    };

    function getMyFormData(id1, id2, name1, name2) {
        var id1Element = id1 && document.querySelector('#' + id1);
        var id2Element = id2 && document.querySelector('#' + id2);
        var objToReturn = {};
        if (id1) {
            objToReturn[name1] = id1Element.value;
        }
        if (id2) {
            objToReturn[name2] = id2Element.value;
        }
        return objToReturn;
    }

    /* var showPrerequisitesForm = document.querySelector('#showPrerequisitesForm');
    showPrerequisitesForm.addEventListener('submit', function(e) {
        e.preventDefault();
        var formData = getMyFormData('departmentCode', 'course', 'departmentCode', 'course');
        console.log('formData', formData);
    });

    var dropStudentForm = document.querySelector('#dropStudentForm');
    dropStudentForm.addEventListener('submit', function(e) {
        e.preventDefault();
        var formData = getMyFormData('bHashdropStudentForm', 'classTasForm', 'bHashdropStudentForm', 'classTasForm');
        console.log('formData', formData);
    });

    var studentEnrollmentForm = document.querySelector('#studentEnrollmentForm');
    studentEnrollmentForm.addEventListener('submit', function(e) {
        e.preventDefault();
        var formData = getMyFormData('bHashstudentEnrollmentForm', 'classClassesForm', 'bHashstudentEnrollmentForm', 'classClassesForm');
        console.log('formData', formData);
    });

    var deleteStudentForm = document.querySelector('#deleteStudentForm');
    deleteStudentForm.addEventListener('submit', function(e) {
        e.preventDefault();
        var formData = getMyFormData('bHashdeleteStudentForm', null, 'bHashdeleteStudentForm', null);
        console.log('formData', formData);
    }); */

    /* var classTaDetailsForm = document.querySelector('#classTaDetailsForm');
    classTaDetailsForm.addEventListener('submit', function(e) {
        e.preventDefault();
        var formData = getMyFormData('classId', null, 'classId', null);
        console.log('formData ', formData);
    }); */


    function showForm(type) {
        var allListItems = Array.from(document.querySelectorAll('.forms'));
        allListItems.forEach(function(element){
            element.className = 'forms hide';
        });
        var formToShow = document.querySelector('#' + type + 'Form');
        formToShow.className = 'forms show';
    }
</script>
</body>
</html>
