<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;

class GalleryController extends Controller
{
    //

    public function index(){
        $urls = $this->get_url();
        [$months,$start_year,$end_year] = $this->get_months();          
        return view('gallery')->with('urls',  array_reverse($urls))->with('months', $months)
        ->with('start_year', $start_year)
        ->with('end_year', $end_year);
    }
    public function get_facets(){
        $url = 'https://rtsp-screenshots.cloud.uiam.sk/cam1/';
        $html = file_get_contents($url);
        $count = preg_match_all('/<a href="([^"]+)(png|jpg|mp4|\/)">[^<]*<\/a>/i', $html, $files);
        $starts_with = '/_11-30/'; // select frames from each day at 12:30
        $new_facets = preg_grep($starts_with,$files[1]);
        $currentDate = Carbon::now();
        $current_month = $currentDate->format('m');
        $current_year = $currentDate->format('Y');
        $current = '/' . $current_year . '-' . $current_month . '/';
        $facets = preg_grep($current,$new_facets);
        $new_facets = array_values($facets);
       
        return $new_facets;
    }

    public function get_url(){
        $data = $this->get_facets();
        $length = count($data);
        for ($i = 0; $i < $length; $i++) {
            $urls[$i] = "https://rtsp-screenshots.cloud.uiam.sk/cam1/".$data[$i]."jpg";
            }

        return $urls;
    }
        
    public function get_months(){
        $months = [
            '01' => 'January',
            '02' => 'February',
            '03' => 'March',
            '04' => 'April',
            '05' => 'May',
            '06' => 'June',
            '07' => 'July',
            '08' => 'August',
            '09' => 'September',
            '10' => 'October',
            '11' => 'November',
            '12' => 'December'
        ];
        $start_year = 2022;
        $end_year = Carbon::now()->year;
        return [$months,$start_year,$end_year];
    }


    public function submit(Request $request)
    {
        [$months,$start_year,$end_year] = $this->get_months();
        $month = $request->input('month');
        $year = $request->input('year');
        if ($month != null && $year != null){
            $years = range($start_year, $end_year);
            $date  = $years[$year] . '-' . $month . '-'; 
            $url = 'https://rtsp-screenshots.cloud.uiam.sk/cam1/';
            $html = file_get_contents($url);
            $count = preg_match_all('/<a href="([^"]+)(png|jpg|mp4|\/)">[^<]*<\/a>/i', $html, $files);
            $starts_with = '/' . $date . '/'; 
            $new_facets = preg_grep($starts_with,$files[1]);
            $hour = '/_11-30/';
            $facets = preg_grep($hour,$new_facets);
            $new_facets = array_values($facets);
            $length = count($new_facets);
            if ($length == 0) {
                $urls = array_reverse($this->get_url()); 
                $info_month = '';
            }else{

                for ($i = 0; $i < $length; $i++) {
                    $urls[$i] = "https://rtsp-screenshots.cloud.uiam.sk/cam1/".$new_facets[$i]."jpg";
                    }
                $info_month = 'from ' . $months[$month] . ' ' . $years[$year];
            }

        }else{
            $urls = array_reverse($this->get_url()); 
            $info_month = '';
        }
    
        [$months,$start_year,$end_year] = $this->get_months(); 
        return view('gallery')->with('urls',$urls)
        ->with('months', $months)
        ->with('start_year', $start_year)
        ->with('end_year', $end_year)
        ->with('info_month', $info_month);
    }
    public function get_timelapse_data(){
        $url = 'https://rtsp-screenshots.cloud.uiam.sk/cam1/';
        $html = file_get_contents($url);
        $count = preg_match_all('/<a href="([^"]+)(png|jpg|mp4|\/)">[^<]*<\/a>/i', $html, $files);
        $starts_with = '/_11-30/';
        $new_facets = preg_grep($starts_with,$files[1]);
        $new_facets = array_values($new_facets);
        return view('timelapse')->with('new_facets', $new_facets);
    }

    

}

