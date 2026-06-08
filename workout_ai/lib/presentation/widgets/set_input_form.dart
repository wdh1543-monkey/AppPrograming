import 'package:flutter/material.dart';

class SetInputForm extends StatefulWidget {
  final void Function(String exercise, double weight, int reps) onAdd;

  const SetInputForm({super.key, required this.onAdd});

  @override
  State<SetInputForm> createState() => _SetInputFormState();
}

class _SetInputFormState extends State<SetInputForm> {
  final _exerciseCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _exerciseCtrl.dispose();
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      _exerciseCtrl.text.trim(),
      double.parse(_weightCtrl.text),
      int.parse(_repsCtrl.text),
    );
    _weightCtrl.clear();
    _repsCtrl.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _exerciseCtrl,
            decoration: const InputDecoration(
              labelText: '종목',
              hintText: '예: 벤치프레스',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? '종목을 입력하세요' : null,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightCtrl,
                  decoration: const InputDecoration(
                    labelText: '무게 (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return '필수';
                    if (double.tryParse(v) == null) return '숫자';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _repsCtrl,
                  decoration: const InputDecoration(
                    labelText: '횟수',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return '필수';
                    if (int.tryParse(v) == null) return '숫자';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16)),
                  child: const Text('추가'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
