# 使用 Ubuntu 20.04 作為基礎映像檔
FROM ubuntu:20.04

# 更新套件列表，並安裝 Python 3.8 以及 pip（Python 套件管理工具）
RUN apt-get update && \
    apt-get install python3.8 -y && \
    apt-get install python3-pip -y

# 安裝特定版本的 pipenv（用於 Python 虛擬環境和依賴管理）
RUN pip install pipenv==2022.4.8

# 建立工作目錄 /dataflow
RUN mkdir /dataflow

# 將當前目錄（與 Dockerfile 同層）所有內容複製到容器的 /dataflow 資料夾
COPY ./src /dataflow/src
COPY ./setup.py /dataflow
COPY ./genenv.py /dataflow
COPY ./Pipfile /dataflow
COPY ./Pipfile.lock /dataflow
COPY ./README.md /dataflow
COPY ./local.ini /dataflow
COPY ./airflow-gce.cfg /dataflow/airflow.cfg

# # 設定容器的工作目錄為 /dataflow，後續的指令都在這個目錄下執行
WORKDIR /dataflow/

# # 根據 Pipfile.lock 安裝所有依賴（確保環境一致性）
RUN pipenv sync

# # 設定語系環境變數，避免 Python 編碼問題
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN echo "UTC" > /etc/timezone

# # 建立 .env
RUN ENV=DOCKER python3 genenv.py

# airflow
ARG AIRFLOW_USER_HOME=/dataflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# # 啟動容器後，預設執行 bash（開啟終端）
CMD ["/bin/bash"]
