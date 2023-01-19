<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArduinoApiController;
use App\Http\Controllers\GalleryController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\UserController;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|#20c9a6
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('index');
});

Route::get('/index', function () {
    return view('index');
});

Route::get('/admin/index', function () {
    return view('index');
});

Route::get('/home', function () {
    return view('index');
});


Route::get('/aboutproject', function () {
    return view('aboutproject');
})->name('aboutproject');



Route::get('/statistics', function () {
    return view('statistics');
})->name('statistics');


Route::get('/livestream', function () {
    return view('livestream');
})->name('livestream');

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

Route::middleware(['user_type'])->group(function () {
   Route::get('/register', [UserController::class,'index'])->name('register');
    
    //Route::get('/control/advanced', function () {
        //return view('control.advanced');
    //})->name('control_advanced');
    
    Route::post('/control/advanced/stored', [App\Http\Controllers\AdvancedFormController::class, 'update_data_form_advanced'])->name('control_advanced.store');
    Route::get('/control/advanced', [App\Http\Controllers\AdvancedFormController::class, 'get_show_values_advanced'])->name('control_advanced');
    
});

Route::get('/control', function () {
    return view('control.index');
})->name('control_index');

Route::post('/control/environment/stored', [App\Http\Controllers\EnvironmentFormController::class, 'update_data_form_control'])->name('control_environment.store');
Route::get('/control/environment', [App\Http\Controllers\EnvironmentFormController::class, 'get_show_values_control'])->name('control_environment');

Route::post('/control/plant/stored', [App\Http\Controllers\PlantFormController::class, 'update_data_form_plant'])->name('control_plant.store');
Route::get('/control/plant', [App\Http\Controllers\PlantFormController::class, 'get_show_values_plant'])->name('control_plant');

Route::get('/gallery', [GalleryController::class, 'index'] )->name('gallery');
Route::post('/gallery', [GalleryController::class, 'submit'])->name('submit');
Route::get('/timelapse', [GalleryController::class, 'get_timelapse_data'])->name('timelapse');

Route::get('/chart', [ArduinoApiController::class, 'getData'] )->name('chart');

Route::get('/current_data', [ArduinoApiController::class, 'getCurrentData'] )->name('current_data');