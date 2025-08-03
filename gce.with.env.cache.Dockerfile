# 使用 Ubuntu 20.04 作為基礎映像檔
FROM wade2468/tibame_dataflow:0.0.7

# 將當前目錄（與 Dockerfile 同層）所有內容複製到容器的 /dataflow 資料夾
COPY ./src /dataflow_wade52/src
COPY ./setup.py /dataflow_wade52
COPY ./genenv.py /dataflow_wade52
COPY ./Pipfile /dataflow_wade52
COPY ./Pipfile.lock /dataflow_wade52
COPY ./README.md /dataflow_wade52
COPY ./local.ini /dataflow_wade52
COPY ./airflow-gce.cfg /dataflow_wade52/airflow.cfg

# # 設定容器的工作目錄為 /dataflow，後續的指令都在這個目錄下執行
WORKDIR /dataflow_wade52/

# # 啟動容器後，預設執行 bash（開啟終端）
CMD ["/bin/bash"]
