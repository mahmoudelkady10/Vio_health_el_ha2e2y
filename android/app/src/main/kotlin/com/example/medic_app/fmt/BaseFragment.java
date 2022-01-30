package com.example.medic_app.fmt;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.StringRes;
import androidx.databinding.DataBindingUtil;
import androidx.databinding.ViewDataBinding;
import androidx.fragment.app.Fragment;

import com.example.medic_app.activity.HealthMonitorActivity;
import com.example.medic_app.health.App;
import com.example.medic_app.health.HcService;
import com.example.medic_app.utils.UToast;

/**
 * Created by ccl on 2017/2/7.
 */

public abstract class BaseFragment extends Fragment {

    protected HealthMonitorActivity mActivity;
    protected HcService mHcService;

    public BaseFragment() {
    }

    @StringRes
    public abstract int getTitle();

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return onCreateBindingView(inflater, container, savedInstanceState).getRoot();
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mActivity = (HealthMonitorActivity) getActivity();
        if (App.isUseCustomBleDevService)
            mHcService = mActivity.mHcService;
    }

    protected ViewDataBinding onCreateBindingView(@Nullable LayoutInflater inflater
            , @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return null;
    }

    protected <T extends ViewDataBinding> T setBindingContentView(LayoutInflater inflater
            , int layoutId, @Nullable ViewGroup parent) {
        return DataBindingUtil.inflate(inflater, layoutId, parent, false);
    }

    public abstract void reset();


    protected void toast(@NonNull String text) {
        UToast.show(getActivity(), text);
    }
    protected void toast(@StringRes int text) {
        UToast.show(getActivity(), text);
    }

}
