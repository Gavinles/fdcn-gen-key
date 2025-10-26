from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/pocc/submit', methods=['POST'])
def submit_pocc():
    data = request.get_json() or {}
    text = data.get('text', '')
    fex = int((len(text) / 10.0) * 10**6) if text else 0
    su = int(len(text) / 20.0) if text else 0
    return jsonify({
        "status": "success",
        "guidance": "Anchor received. The system reflects your input.",
        "tx_status": "simulated",
        "scores": {"fex": fex, "su": su}
    })


@app.route('/healthz', methods=['GET'])
def healthz():
    # lightweight health check — extend with readiness checks as needed
    return jsonify({"status": "ok"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
