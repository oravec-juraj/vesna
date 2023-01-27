@extends('_layouts.app')

@section('content')
<form class="jotform-form" action="/control/advanced/stored" method="post" name="form_223545201974354" id="223545201974354" accept-charset="utf-8" autocomplete="off">
  @csrf  
  <div role="main" class="form-all">
    <style>
      .form-all:before
      {
        background: none;
      }
    </style>
    <ul class="form-section page-section">
      <li id="cid_1" class="form-input-wide" data-type="control_head">
        <div class="form-header-group  header-large">
          <div class="header-text httal htvam">
            <h1 id="header_1" class="form-header" data-component="header">{{__('advanced.caption')}}</h1>
          </div>
        </div>
      </li>
      <li id="cid_31" class="form-input-wide" data-type="control_head">
        <div class="form-header-group  header-small">
          <div class="header-text httac htvam">
            <h3 id="header_31" class="form-header" data-component="header">{{__('advanced.discrete')}}</h3>
          </div>
        </div>
      </li>
      <li class="form-line form-line-column form-col-1" data-type="control_number" id="id_11">
        <label class="form-label form-label-top" id="label_11" for="sampling"> {{__('advanced.sampling')}} </label>
        <div id="cid_11" class="form-input-wide" data-layout="half"> 
          <span class="form-sub-label-container" style="vertical-align:top">
            <input type="number" id="sampling" name="sampling" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$sampling_show}}" min="60" max="1500" data-component="number" aria-labelledby="label_11 sublabel_input_11" step="any" /> 
            <label class="form-sub-label" for="sampling" id="sublabel_input_11" style="min-height:13px" aria-hidden="false">{{__('advanced.times')}}</label>
          </span> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-2" data-type="control_number" id="id_13">
        <label class="form-label form-label-top" id="label_13" for="z_r"> {{__('advanced.P_c')}} </label>
        <div id="cid_13" class="form-input-wide" data-layout="half"> 
          <input type="number" id="z_r" name="z_r" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$z_r_show}}" min="45" max="200" data-component="number" aria-labelledby="label_13" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-3" data-type="control_number" id="id_14">
        <label class="form-label form-label-top" id="label_14" for="t_i"> {{__('advanced.I_c')}} </label>
        <div id="cid_14" class="form-input-wide" data-layout="half"> 
          <input type="number" id="t_i" name="t_i" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$t_i_show}}" min="6" max="100" data-component="number" aria-labelledby="label_14" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-4" data-type="control_number" id="id_27">
        <label class="form-label form-label-top" id="label_27" for="t_d"> {{__('advanced.D_c')}} </label>
        <div id="cid_27" class="form-input-wide" data-layout="half"> 
          <input type="number" id="t_d" name="t_d" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$t_d_show}}" min="0" max="60" data-component="number" aria-labelledby="label_27" step="any" /> 
        </div>
      </li>
      <li id="cid_34" class="form-input-wide" data-type="control_head">
        <div class="form-header-group  header-small">
          <div class="header-text httac htvam">
            <h3 id="header_34" class="form-header" data-component="header">{{__('advanced.ventilation_s')}}</h3>
          </div>
        </div>
      </li>
      <li class="form-line form-line-column form-col-4" data-type="control_number" id="id_29">
        <label class="form-label form-label-top" id="label_29" for="vent_duration"> {{__('advanced.duration')}} </label>
        <div id="cid_29" class="form-input-wide" data-layout="half"> 
          <span class="form-sub-label-container" style="vertical-align:top">
            <input type="number" id="vent_duration" name="vent_duration" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$vent_duration_show}}" min="900" max="2000" data-component="number" aria-labelledby="label_29 sublabel_input_29" step="any" /> 
            <label class="form-sub-label" for="vent_duration" id="sublabel_input_29" style="min-height:13px" aria-hidden="false">{{__('advanced.times')}}</label>
          </span> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-5" data-type="control_number" id="id_30">
        <label class="form-label form-label-top" id="label_30" for="vent_start"> {{__('advanced.ventilation_p')}} </label>
        <div id="cid_30" class="form-input-wide" data-layout="half"> 
          <span class="form-sub-label-container" style="vertical-align:top">
            <input type="number" id="vent_start" name="vent_start" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$vent_start_show}}" min="7200" max="10000" data-component="number" aria-labelledby="label_30 sublabel_input_30" step="any"></input> 
            <label class="form-sub-label" for="vent_start" id="sublabel_input_30" style="min-height:13px" aria-hidden="false">{{__('advanced.times')}}</label>
          </span> 
        </div>
      </li>
      <li class="form-line" data-type="control_button" id="id_2">
        <div id="cid_2" class="form-input-wide" data-layout="full">
          <div data-align="auto" class="form-buttons-wrapper form-buttons-auto   jsTest-button-wrapperField"><button id="input_2" type="submit" class="form-submit-button form-submit-button-simple_green_apple submit-button jf-form-buttons jsTest-submitField" data-component="button" data-content="">{{__('advanced.submit')}}</button></div>
        </div>
      </li>
      <li style="clear:both"></li>
    </ul>
  </div>
</form>
@endsection('content')

