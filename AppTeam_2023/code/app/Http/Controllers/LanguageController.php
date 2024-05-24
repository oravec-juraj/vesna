<?php

namespace App\Http\Controllers;
use App;

use Illuminate\Http\Request;

class LanguageController extends Controller
{
    public function language($locale) 
    {
        App::setLocale($locale);
        session()->put('locale', $locale);
        return redirect()->back();
    }
}
