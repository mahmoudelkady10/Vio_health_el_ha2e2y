package com.example.medic_app.fmt;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.ViewDataBinding;

import com.linktop.MonitorDataTransmissionManager;
import com.linktop.infs.OnSpO2ResultListener;
import com.linktop.whealthService.MeasureType;
import com.linktop.whealthService.task.OxTask;

import com.example.medic_app.bean.SpO2;
import com.example.medic_app.health.App;
import technotown.technology.viohealth.R;
import technotown.technology.viohealth.databinding.FragmentSpo2Binding;
import com.example.medic_app.widget.WaveSurfaceView;
import com.example.medic_app.widget.wave.PPGDrawWave;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

import lib.linktop.obj.DataFile;
import lib.linktop.sev.HmLoadDataTool;

/**
 * Created by ccl on 2017/2/7.
 * SpO2测量界面
 */

public class SPO2Fragment extends MeasureFragment implements OnSpO2ResultListener {

    private SpO2 model;
    private OxTask mOxTask;
    private PPGDrawWave oxWave;
    private WaveSurfaceView waveView;

    public SPO2Fragment() {
    }

    @Override
    public boolean startMeasure() {
        waveView.reply();
        if (mOxTask != null) {
            mOxTask.start();
        } else {
            MonitorDataTransmissionManager.getInstance().startMeasure(MeasureType.SPO2);
        }
        return true;
    }

    @Override
    public void stopMeasure() {
        if (mOxTask != null) {
            mOxTask.stop();
        } else {
            MonitorDataTransmissionManager.getInstance().stopMeasure();
        }
        waveView.pause();
    }

    @Override
    public void clickUploadData(View v) {
        if (model == null || model.isEmptyData()) {
            toast("不能上传空数据");
            return;
        }
        HmLoadDataTool.getInstance().uploadData(DataFile.DATA_SPO2, model);
    }

    @Override
    public int getTitle() {
        return R.string.spo2;
    }

    @NonNull
    @Override
    protected ViewDataBinding onCreateBindingView(LayoutInflater inflater,
                                                  @Nullable ViewGroup container,
                                                  @Nullable Bundle savedInstanceState) {
        FragmentSpo2Binding binding = setBindingContentView(inflater, R.layout.fragment_spo2, container);
        binding.setContent(this);
        binding.setShowUpload(App.isShowUploadButton);
        oxWave = new PPGDrawWave();
        waveView = binding.ppgWave;
        waveView.setDrawWave(oxWave);
        this.btnMeasure = binding.btnMeasure;
        model = new SpO2();
        binding.setModel(model);
        return binding;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        waveView.pause();
        if (mHcService != null) {
            mOxTask = mHcService.getBleDevManager().getOxTask();
            mOxTask.setOnSpO2ResultListener(this);
        } else {
            MonitorDataTransmissionManager.getInstance().setOnSpO2ResultListener(this);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void reset() {
        model.reset();
        oxWave.clear();
    }

    @SuppressLint("NewApi")
    @Override
    public void onSpO2Result(int spo2, int hr) {
        Context context = getContext();
        assert context != null;
        SharedPreferences sharedPreferences = context.getSharedPreferences("Data", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        editor.putString("spo2", String.valueOf(spo2));
        editor.putString("heart_rate_spo2", String.valueOf(hr));
        editor.putString("date_spo2", String.valueOf(LocalDateTime.now().format(myFormatObj)));
        editor.apply();
        model.setValue(spo2);
        model.setHr(hr);
    }

    @Override
    public void onSpO2Wave(int value) {
        oxWave.addData(value);
    }

    @Override
    public void onSpO2End() {
        model.setTs(System.currentTimeMillis() / 1000L);
        resetState();
    }

    @Override
    public void onFingerDetection(int state) {
        if (state == FINGER_NO_TOUCH) {
            stopMeasure();
            model.setValue(0);
            model.setHr(0);
            toast("No finger was detected on the SpO₂ sensor.");
        }
    }
}
