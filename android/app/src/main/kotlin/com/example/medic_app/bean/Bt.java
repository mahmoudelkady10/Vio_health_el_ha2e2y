package com.example.medic_app.bean;

import androidx.databinding.BaseObservable;
import androidx.databinding.Bindable;
import android.util.Log;

import lib.linktop.obj.LoadBtBean;
import technotown.technology.technoclinic.BR;

/**
 * Created by ccl on 2017/2/23.
 * Body Temperature.
 */

public class Bt extends BaseObservable implements LoadBtBean {

//    private static final String CHANNEL = "AndySample/test";
//
//    public void onCreate(@NonNull FlutterEngine flutterEngine) {
//        MethodChannel mc=new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL);
//        mc.setMethodCallHandler((methodCall, result) ->
//                {
//                    if(methodCall.method.equals("test"))
//                    {
//                        result.success(getTemp());
////Accessing data sent from flutter
//                    }
//                    else
//                    {
//                        Log.i("new method came",methodCall.method);
//                    }
//
//                }
//        );
//    }

    private long ts = 0;
    private double temp = 0.0d;

    public Bt() {
    }

    public Bt(long ts, double temp) {
        this.ts = ts;
        this.temp = temp;
    }

    @Override
    public long getTs() {
        return ts;
    }

    @Override
    public void setTs(long ts) {
        this.ts = ts;
    }

    @Bindable
    @Override
    public double getTemp() {
        return temp;
    }

    @Override
    public void setTemp(double temp) {
        if (this.temp != temp) {
            this.temp = temp;
            notifyPropertyChanged(BR.temp);
        }
    }

    public void reset() {
        Log.e("BT", "reset");
        temp = 0.0d;
        ts = 0L;
        notifyChange();
    }

    public boolean isEmptyData() {
        return temp == 0.0d || ts == 0L;
    }

    @Override
    public String toString() {
        return "Bt{" +
                "ts=" + ts +
                ", temp=" + temp +
                '}';
    }
}
