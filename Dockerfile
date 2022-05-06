FROM nightseas/cuda-torch:cuda8.0-ubuntu16.04
SHELL ["/bin/bash", "-c"]

COPY cunn-scm-1.rockspec nn_init_diff.lua optim_init_diff.lua luarocks_config.lua thcunn_headers /root/patches/
RUN git clone https://github.com/fqnchina/IntrinsicImage.git && \
    cp patches/luarocks_config.lua ~/torch/install/etc/luarocks/config.lua && \
    cp IntrinsicImage/compile/{ComputeXGrad.lua,ComputeYGrad.lua,DomainTransform.lua,EdgeComputation.lua,IIWscale.lua,WHDRHingeLossPara.lua} torch/extra/nn && \
    cd ~/torch/extra/nn && \
    output=$(head -n -2 init.lua; cat ~/patches/nn_init_diff.lua; tail -n -2 init.lua) && \
    echo "$output" > init.lua && \
    luarocks make ./rocks/nn-scm-1.rockspec && \
    cd ~ && \
    cp IntrinsicImage/compile/{*.cu,*.h} torch/extra/cunn/lib/THCUNN && \
    cat ~/patches/thcunn_headers | sed -i '${x;s/.*/cat/e;p;x}' ~/torch/extra/cunn/lib/THCUNN/generic/THCUNN.h  && \
    cd /root/torch/extra/cunn && \
    cp ~/patches/cunn-scm-1.rockspec ./rocks/cunn-scm-1.rockspec && \
    luarocks make ./rocks/cunn-scm-1.rockspec && \
    cd ~ && \
    cp IntrinsicImage/compile/adam_state.lua torch/pkg/optim/ && \
    cd torch/pkg/optim && \
    output=$(head -n -2 init.lua; cat ~/patches/optim_init_diff.lua; tail -n -2 init.lua) && \
    echo "$output" > init.lua && \
    luarocks make optim-1.0.5-0.rockspec && \
    cd ~ && \
    rm -rf IntrinsicImage patches .cache
