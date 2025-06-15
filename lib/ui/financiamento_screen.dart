import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimuladorFinanciamentoScreen extends StatefulWidget {
  const SimuladorFinanciamentoScreen({Key? key}) : super(key: key);

  @override
  _SimuladorFinanciamentoScreenState createState() => _SimuladorFinanciamentoScreenState();
}

class _SimuladorFinanciamentoScreenState extends State<SimuladorFinanciamentoScreen> {
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerJuros = TextEditingController();
  final TextEditingController _controllerParcelas = TextEditingController();
  final TextEditingController _controllerTaxasExtras = TextEditingController();

  double _montanteFinal = 0.0;
  double _valorParcelaMensal = 0.0;

  void _executarSimulacao() {
    final double valorPrincipal = double.tryParse(_controllerValor.text) ?? 0.0;
    final double jurosMensais = (double.tryParse(_controllerJuros.text) ?? 0.0) / 100;
    final int quantidadeParcelas = int.tryParse(_controllerParcelas.text) ?? 0;
    final double custosAdicionais = double.tryParse(_controllerTaxasExtras.text) ?? 0.0;

    if (quantidadeParcelas > 0) {
      setState(() {
        final double valorTotalComJuros = valorPrincipal * pow(1 + jurosMensais, quantidadeParcelas) + custosAdicionais;
        _montanteFinal = valorTotalComJuros;
        _valorParcelaMensal = valorTotalComJuros / quantidadeParcelas;
      });
    } else {
      setState(() {
        _montanteFinal = 0.0;
        _valorParcelaMensal = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulação de Juros'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'Valor do empréstimo:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controllerValor,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: _inputDecoration('Digite o valor em R\$'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Taxa de juros mensal:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controllerJuros,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: _inputDecoration('Ex: 2.5%', suffix: '%'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quantidade de parcelas:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controllerParcelas,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration('Ex: 12'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Custos adicionais:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controllerTaxasExtras,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: _inputDecoration('Digite os custos extras'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _executarSimulacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text(
                'Simular',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Montante final: R\$ ${_montanteFinal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Valor da parcela: R\$ ${_valorParcelaMensal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {String? suffix}) {
    return InputDecoration(
      hintText: hint,
      suffixText: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
