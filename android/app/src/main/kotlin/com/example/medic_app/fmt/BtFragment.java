package com.example.medic_app.fmt;

import android.annotation.SuppressLint;
import android.content.SharedPreferences;
import android.content.Context;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.databinding.ObservableBoolean;
import androidx.databinding.ViewDataBinding;

import com.linktop.MonitorDataTransmissionManager;
import com.linktop.infs.OnBtResultListener;
import com.linktop.whealthService.MeasureType;
import com.linktop.whealthService.task.BtTask;

import com.example.medic_app.bean.Bt;
import com.example.medic_app.health.App;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import technotown.technology.viohealth.R;
import technotown.technology.viohealth.databinding.FragmentBtBinding;

import lib.linktop.obj.DataFile;
import lib.linktop.sev.HmLoadDataTool;

/**
 * Created by ccl on 2017/2/7.
 */

public class BtFragment extends MeasureFragment
        implements OnBtResultListener {

    private final ObservableBoolean isUnitF = new ObservableBoolean(false);
    private Bt model;
    private BtTask mBtTask;

    public BtFragment() {
    }

    @Override
    public boolean startMeasure() {
        if (mBtTask != null) {
            mBtTask.start();
        } else {
            MonitorDataTransmissionManager.getInstance().startMeasure(MeasureType.BT);
        }
        return true;
    }

    @Override
    public void stopMeasure() {
        //BT module is not have method stop().Because it will return result in 2~4 seconds when you click to start measure.

//        if(mBtTask!= null) {
//            mBtTask.stop();
//        } else {
//            MonitorDataTransmissionManager.getInstance().stopMeasure();
//        }

    }

    @Override
    public void clickUploadData(View v) {
        if (model == null || model.isEmptyData()) {
            toast("不能上传空数据");
            return;
        }
        HmLoadDataTool.getInstance().uploadData(DataFile.DATA_BT, model);
    }

    @Override
    public int getTitle() {
        return R.string.body_temperature;
    }

    @Override
    protected ViewDataBinding onCreateBindingView(LayoutInflater inflater
            , @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        FragmentBtBinding binding = setBindingContentView(inflater, R.layout.fragment_bt, container);
        binding.setContent(this);
        binding.setShowUpload(App.isShowUploadButton);
        this.btnMeasure = binding.btnMeasure;
        model = new Bt();
        binding.setIsUnitF(isUnitF);
        binding.setModel(model);
        binding.switchUnit.setOnCheckedChangeListener((buttonView, isChecked) ->
                isUnitF.set(isChecked));
        return binding;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (mHcService != null) {
            mBtTask = mHcService.getBleDevManager().getBtTask();
            mBtTask.setOnBtResultListener(this);
        } else {
            MonitorDataTransmissionManager.getInstance().setOnBtResultListener(this);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void reset() {
        model.reset();
    }

    /*
     * 默认返回单位为摄氏度的温度值，若需要华氏度的温度值，根据公式转换
     * 本Demo使用Databinding的方式，详情请看该布局的温度显示控件TextView
     * */
    @SuppressLint("NewApi")
    @Override
    public void onBtResult(double tempValue) {
        Context context = getContext();
        assert context != null;
        SharedPreferences sharedPreferences = context.getSharedPreferences("Data", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString("body_temp", String.valueOf(tempValue));
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        editor.putString("date_bt", String.valueOf(LocalDateTime.now().format(myFormatObj)));
        editor.apply();
        model.setTemp(tempValue);
        model.setTs(System.currentTimeMillis() / 1000L);
        resetState();
    }


}
