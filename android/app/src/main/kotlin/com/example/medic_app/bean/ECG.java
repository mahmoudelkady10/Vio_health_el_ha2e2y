package com.example.medic_app.bean;

import android.text.TextUtils;

import androidx.databinding.BaseObservable;
import androidx.databinding.Bindable;

import java.io.Serializable;

import technotown.technology.vioclinic.BR;
import lib.linktop.obj.LoadECGBean;

/**
 * Created by ccl on 2017/2/8.
 */

public class ECG extends BaseObservable implements LoadECGBean, Serializable {

    private long ts;
    private long duration;
    private int rrMax;//max value of R-R interval
    private int rrMin;//min value of R-R interval
    private int hr;//heart rate
    private int hrv;//heart rate variability
    private int mood;
    private int rr;//Respiratory rate
    private String wave;

    public ECG() {
    }

    public ECG(long ts, long duration, int rrMax, int rrMin, int hr, int hrv, int mood, int rr, String wave) {
        this.ts = ts;
        this.duration = duration;
        this.rrMax = rrMax;
        this.rrMin = rrMin;
        this.hr = hr;
        this.hrv = hrv;
        this.mood = mood;
        this.rr = rr;
        this.wave = wave;
    }

    @Bindable
    @Override
    public int getRRMax() {
        return rrMax;
    }

    @Override
    public void setRRMax(int rrMax) {
        if (this.rrMax != rrMax) {
            this.rrMax = rrMax;
            notifyPropertyChanged(BR.rRMax);
        }
    }

    @Bindable
    @Override
    public int getRRMin() {
        return rrMin;
    }

    @Override
    public void setRRMin(int rrMin) {
        if (this.rrMin != rrMin) {
            this.rrMin = rrMin;
            notifyPropertyChanged(BR.rRMin);
        }
    }

    @Bindable
    @Override
    public int getHr() {
        return hr;
    }

    @Override
    public void setHr(int hr) {
        if (this.hr != hr) {
            this.hr = hr;
            notifyPropertyChanged(BR.hr);
        }
    }

    @Bindable
    @Override
    public int getHrv() {
        return hrv;
    }

    @Override
    public void setHrv(int hrv) {
        if (this.hrv != hrv) {
            this.hrv = hrv;
            notifyPropertyChanged(BR.hrv);
        }
    }

    @Bindable
    @Override
    public int getMood() {
        return mood;
    }

    public void setMood(int mood) {
        if (this.mood != mood) {
            this.mood = mood;
            notifyPropertyChanged(BR.mood);
        }
    }

    @Bindable
    @Override
    public int getRr() {
        return rr;
    }

    @Override
    public void setRr(int rr) {
        if (this.rr != rr) {
            this.rr = rr;
            notifyPropertyChanged(BR.rr);
        }
    }

    @Bindable
    @Override
    public long getDuration() {
        return duration;
    }

    @Override
    public void setDuration(long duration) {
        if (this.duration != duration) {
            this.duration = duration;
            notifyPropertyChanged(BR.duration);
        }
    }

    @Override
    public void setWave(String wave) {
        this.wave = wave;
    }

    @Override
    public String getWave() {
        return wave;
    }

    @Override
    public long getTs() {
        return ts;
    }

    @Override
    public void setTs(long ts) {
        this.ts = ts;
    }

    public void reset() {
        rrMax = 0;
        rrMin = 0;
        hr = 0;
        hrv = 0;
        mood = 0;
        rr = 0;
        duration = 0L;
        ts = 0L;
        wave = "";
        notifyChange();
    }

    public boolean isEmptyData() {
        return rrMax == 0 ||
                rrMin == 0 ||
                hr == 0 ||
                hrv == 0 ||
                mood == 0 ||
                rr == 0 ||
                duration == 0L ||
                ts == 0L ||
                TextUtils.isEmpty(wave);
    }
}
