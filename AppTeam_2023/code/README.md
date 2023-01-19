# App Team - VESNA web page    

- [Requirements](#Requirements)
- [How to Install and Run the Project](#How-to-Install-and-Run-the-Project)
- [Project Documentation](#Project-documentation)
- [Control Forms](#Control-Forms)
------------
## Requirements
Laravel web page requires the following to run:
  * [Visual studio code][visual] or an alternative code editor
  * [XAMPP][XAMPP] or an alternative Apache + MySQL web server
  * [Node.js][node] 
    * [npm][npm] (normally comes with Node.js)
  * [Composer][composer] Dependency Manager for PHP (PHP version 8.0.0 or higher)

[visual]: https://code.visualstudio.com/
[XAMPP]: https://www.apachefriends.org/ 
[node]: https://nodejs.org/
[npm]: https://www.npmjs.com/
[composer]: https://getcomposer.org/

Verify versions of requirements using following commands in the command line:
```bash
php -ver
```
```bash
composer -V
```
```bash
npm -v
```
## How to Install and Run the Project
1. Use
```bash
git clone #using the github https URL
```
2. Open XAMPP and run **Apache** and **MySQL** module.
3. Click on _Admin_ next to MySQL module to access **phpMyAdmin**.
4. Under user accounts click on _Add user account_.
5. Save password from **Login information** for later.
6. Open the project folder in Visual Studio code.
7. Create file **.env** from **.env.example**:  
    * add connection to your MySQL database  
    * add Arduino cloud API key and secret (bottom of the file)
8. Use following commands in terminal to install composer and node packages:
```bash
composer install
npm install
npm run build
```
9. Run command in terminal to run migrations
```bash
php artisan migrate:fresh --seed
```
10. Run command in terminal to generate application key
```bash
php artisan key:generate
```
11. Run command in terminal to run web server on local machine
```bash
php artisan serve
```

Admin and user credentials:
Login for admin and one user were created using UserSeeder. Login credentials:

Admin email: admin@vesna.com
Admin password: secret

User email: user@vesna.com
User password: secret

------------
## Project Documentation

### BOOTSTRAP TEMPLATE
Template was downloaded from https://startbootstrap.com and then folders css, img, js and vendor were copied into public folder in our application. 
File index.html copied into folder resources/views and renamed to index.blade.php, made route in web.php to index.blade.php
File app.blade.php contained part Sidebar, this part was cut and pasted into navbar.blade.php and then @include('_layouts.navbar') was pasted into app.blade.php at the place, where Sidebar was originally sidebar.
Part Begin Page Content in app.blade.php was cut and pasted into index.blade.php and at its original place in app.blade.php @yield('content') was inserted.
Each new blade needs to contain following:
```bash
@extends('_layouts.app')
@section('content')

Content of the page.

@endsection('content')
```

### AUTHENTIFICATION
Commands in terminal:
```bash
composer require laravel/ui
php artisan ui bootstrap –auth
npm install
npm run build
php artisan migrate
php artisan make:seeder UserSeeder
```

Updated public fuction run() in UserSeeder, and subsequently run command 
```bash
php artisan migrate:fresh –seed 
```
in terminal.
Restrictions according to roles:
```bash
php artisan make:middleware RestrictByUserType
```
In RestrictByUserType.php was filled public function handle.
In web.php add:
```bash
Auth::routes();
```
Add ‘user_type ’ in protected $routeMiddleware in app\Kernel.php:

```bash
protected $routeMiddleware = [
    'auth' => \App\Http\Middleware\Authenticate::class,
    …
    'user_type' => \App\Http\Middleware\RestrictByUserType::class,
];
```
For restricting routhes according to role, in web.php
```bash
Route::middleware(['user_type'])->group(function () {
...
}); 
```
was added. Navbar was adjusted, so that only admin has access to advanced control and other pages of control and timlapse and gallery are only shown for signed-up users. 

### CAMERA
1.	Download and install the Reolink software on your computer or mobile device from the Reolink [website](https://reolink.com/software-and-manual/).
2.	Open the software and click on "Add Camera" to add your Reolink camera to the software.
3.	Fill in the camera's IP address, username, and password provided by project supervisor.
4. Once the camera is added, you will be able to view the live feed from the camera on the software.
5. If you want to set up livestream locally, follow these steps:
   1. Open VLC media player and click on the "Media" menu at the top of the screen.
    2. Select "Open Network Stream."
    3. In the "Network" tab, enter the RTSP URL: __rtsp://cloud.uiam.sk:8554/cam1__
    4. Click the "Play" button to start the video stream.

### LIVESTREAM
Livestream is set up using the website [RTSP.me](https://rtsp.me/en/#create). If you want to create new livestream broadcasting with RTSP, enter RTSP LINK, your email and choose data center location. After creating new URL, you can change __src__ in __resources/views/livestream.blade.php__.
```bash
<div> 
    <iframe width="960" height="540" src="https://rtsp.me/embed/NittknB4/" frameborder="0" allowfullscreen></iframe>
</div>
```
### GALLERY
Minute snapshots are stored in [UIAM cloud](https://rtsp-screenshots.cloud.uiam.sk/cam1/). 
```bash
\resources\views\gallery.blade.php
```
The gallery is provided by [fotorama](https://fotorama.io/docs/4/). The form is used to select the exact month and year to view the records from that month every day at 12:30. 
```bash
\app\Http\Controllers\Gallery.php
```
1. The method __get_facets()__ return the array with snapshots date title in the form of __yyyy-MM-dd_THH-mm__.
2. The method __get_url()__ return the URLs of snapshots. If you want the change the change the snaphot selector, e.g. show only the snapshots from the december 2022, modify __get_facets()__ to 
```bash
$starts_with = '/2022-12-/'.
```
3. The method __sumbit()__ return the URLs of snaphots selected by sumbitted month and year. If the snapshots from submitted month and year are not stored in cloud yet, the method return the URLs of snapshots from current year.

### Control Forms 
Three forms are created in order to control the greenhouse. They are used for different purposes.
```bash
\resources\views\control\advanced.blade.php
\resources\views\control\environment.blade.php
\resources\views\control\plant.blade.php
```
Moreover, there is a controller for each of them as well.
```bash
\app\Http\Controllers\AdvancedFormController.php
\app\Http\Controllers\EnvironmentFormController.php
\app\Http\Controllers\PlantFormController.php
\app\Http\Controllers\PlantIDController.php         # is used for store all the attributes of each plant
\app\Http\Controllers\AdminGuestController.php      # is used for sending control parameters - hierarchy to Arduino Cloud everytime some variable changes
```
In each controller there are functions for storing the pid of each variable. They also display the last values before submitting, display them in placeholders and for sending updated values to the Arduino Cloud. Each function is explained in each controller.

#### Advanced Form
This form is used to control the PID controller of the temperature and to set the duration of the ventilation or period.

| Variable |  Name in code  | Name in Cloud | Threshold | MIN value | MAX value | Type in Cloud
|:-----|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|Sampling Time | sampling | sampling | 60 | 60 | 1500 | Time |
|Proportional Constant| z_r | z_r | 45 | 45 | 200 | Float |
|Integration constant| t_i | t_i |6 | 6| 100 | Float |
|Derivative constant| t_d | t_d |0 | 0| 60 | Float |
|Duration of ventilation| vent_duration | vent_duration |900 | 900| 2000 | Time |
|Ventilation period| vent_start | vent_start |7200 | 7200| 10000 | Time |

### Environment Form 
This form is used to turn on and off variables such as humidification, lighting, fans and irrigation.
| Variable |  Name in code  | Name in Cloud | Threshold | MIN value | MAX value | Type in Cloud
|:-----|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|Control of humidification | pump | pump | 0 | 0 | 255 | Integer |
|Control of lighting| lighting | lighting | 0 | 0 | 255 | Integer |
|Control of ventilation| fans | fans |0 | 0| 255 | Integer |
|Control of irrigation| irrigator | irrigator |0 | 0| 255 | Integer |

### Plant Form
The form is used to select a plant, where the values are sent as soon as the plant is changed and other values such as luminosity, maximum temperature, etc.
| Variable |  Name in code  | Name in Cloud | Threshold | MIN value | MAX value | Type in Cloud
|:-----|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|Choice of plant | plant_id | plant_id | 1 | 1 | 13 | Integer |
|Intensity minimum required for luminosity| luminosity | luminosity | 1500 | 1500 | 3000 | Float |
|The maximum temperature for growth| temp_max | temp_max |31 | 31| 35 | Float |
|Temperature setpoint during the day| w_day | w_day |22 | 22| 35 | Float |
|Temperature setpoint during the night| w_night | w_night |18 | 18| 35 | Float |
|Minimum recommended humidity | hum_min | hum_min |48 | 48| 100 | Float |
|Maximum recommended humidity | hum_max | hum_max|52 | 52| 100 | Float |
|End of daily control | time_up | time_up|72000 | 72000| 86400 | Time |
|Start of daily control | time_down | time_down|21600 | 21600| 86400 | Time |
