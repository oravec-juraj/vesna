@extends('_layouts.app')

@section('content')
<!DOCTYPE html>
<html>
<head>
<title>Project VESNA</title>
<style>p{text-align: justify;}</style>
</head>
<body>

<h1 class="h1 mb-0 text-gray-800">About VESNA</h1>
   <p>VESNA (an acronym for Versatile Simulator for Near-zero Emissions Agriculture) is a Smart Eco Greenhouse developed by young researches and students.
   The design of the greenhouse is equipped with advanced electronics. The environment inside the greenhouse can be monitored using a number of sensors that measure temperature,
    humidity, lighting, air quality and more. The microclimate in the greenhouse can be controlled by heating or humidifying the air, lighting with Grow LED strips, 
    automated ventilation and more. The greenhouse communicates via a wireless internet connection with a computer that seeks to provide autonomous control without the need
     for human intervention.</p>
   <p> This project takes part in the student subject Project on process control. Students working on the subtasks of the VESNA are divided into three teams: Core Team, Smart Team and App Team.</p> 

   <h4><b>Core Team</b></h4>
   <p>The Core Team brings VESNA to the life through  microcontrollers, sensors, communication and control elements, which include valves, pumps, heaters, 
 fans, Grow LED strips for optimal plant lighting and an irrigation system.</p>

   <h4><b>Smart Team</b></h4>
   <p>The Smart Team creates the intelligence of the smart eco greenhouse device by introducing self-awareness into autonomous decision-making without 
the necessity of manual external interventions.</p>

   <h4><b>App Team</b></h4>
   <p>The main goal of the App Team is to develop a web interface that provides remote supervision of the intelligent greenhouse and visualizes data in a user-friendly way.
      This team operates with environments of web technologies and cloud technologies. </p>


<p> For more information visit <a href="https://vesna.uiam.sk/">official page</a>. </p>

</body>
</html>
@endsection('content')