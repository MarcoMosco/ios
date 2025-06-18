import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cognomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _ospedaleController = TextEditingController();
  String? _spedizione;
  final _dettagliSpedizioneController = TextEditingController();
  String? _causale;
  DateTime? _dataIntervento;
  DateTime? _dataConsegna;
  DateTime? _dataRitiro;
  final _contattoRitiroController = TextEditingController();
  bool _formValid = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cognomeController.dispose();
    _emailController.dispose();
    _ospedaleController.dispose();
    _dettagliSpedizioneController.dispose();
    _contattoRitiroController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _formValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, ValueChanged<DateTime?> onChanged) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onChanged(picked);
      _validateForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DISTINTA D'ORDINE"),
        backgroundColor: const Color(0xFFB1001A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome *'),
                      validator: (v) => v == null || v.isEmpty ? 'Campo obbligatorio' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cognomeController,
                      decoration: const InputDecoration(labelText: 'Cognome *'),
                      validator: (v) => v == null || v.isEmpty ? 'Campo obbligatorio' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'esempio@esempio.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obbligatorio';
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(v)) {
                    return 'Email non valida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ospedaleController,
                decoration: const InputDecoration(
                  labelText: 'Ospedale, nome medico e reparto utilizzatore *',
                ),
                minLines: 2,
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'Campo obbligatorio' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _spedizione,
                decoration: const InputDecoration(labelText: 'Note per la spedizione *'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Seleziona', style: TextStyle(color: Colors.grey)), enabled: false),
                  DropdownMenuItem(value: 'Spedizione diretta', child: Text('Spedizione diretta')),
                  DropdownMenuItem(value: 'Fermo DHL', child: Text('Fermo DHL')),
                  DropdownMenuItem(value: 'Fermo TNT', child: Text('Fermo TNT')),
                ],
                validator: (v) => v == null ? 'Campo obbligatorio' : null,
                onChanged: (v) {
                  setState(() => _spedizione = v);
                  _validateForm();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dettagliSpedizioneController,
                decoration: const InputDecoration(labelText: 'Dettagli aggiuntivi spedizione'),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _causale,
                decoration: const InputDecoration(labelText: 'Causale *'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Seleziona', style: TextStyle(color: Colors.grey)), enabled: false),
                  DropdownMenuItem(value: 'Visione', child: Text('Visione')),
                  DropdownMenuItem(value: 'Deposito', child: Text('Deposito')),
                  DropdownMenuItem(value: 'Reintegro', child: Text('Reintegro')),
                  DropdownMenuItem(value: 'Intervento spot', child: Text('Intervento spot')),
                ],
                validator: (v) => v == null ? 'Campo obbligatorio' : null,
                onChanged: (v) {
                  setState(() => _causale = v);
                  _validateForm();
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FormField<DateTime>(
                      validator: (value) {
                        if (_dataIntervento == null) {
                          return 'Campo obbligatorio';
                        }
                        return null;
                      },
                      builder: (field) => InkWell(
                        onTap: () => _selectDate(context, _dataIntervento, (d) => setState(() => _dataIntervento = d)),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Data intervento *',
                            errorText: field.errorText,
                          ),
                          child: Text(
                            _dataIntervento == null ? 'Seleziona data' : _dataIntervento!.toLocal().toString().split(' ')[0],
                            style: TextStyle(
                              color: _dataIntervento == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, _dataConsegna, (d) => setState(() => _dataConsegna = d)),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Data consegna di preferenza'),
                        child: Text(
                          _dataConsegna == null ? 'Seleziona data' : _dataConsegna!.toLocal().toString().split(' ')[0],
                          style: TextStyle(
                            color: _dataConsegna == null ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, _dataRitiro, (d) => setState(() => _dataRitiro = d)),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Data ritiro'),
                        child: Text(
                          _dataRitiro == null ? 'Seleziona data' : _dataRitiro!.toLocal().toString().split(' ')[0],
                          style: TextStyle(
                            color: _dataRitiro == null ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _contattoRitiroController,
                      decoration: const InputDecoration(labelText: 'Nominativo di contatto per il ritiro'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_formValid)
                Column(
                  children: [
                    const Text(
                      'Form compilato correttamente',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB1001A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ArticoliScreen()),
                        );
                      },
                      child: const Text("Procedi all'ordine"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticoliScreen extends StatelessWidget {
  const ArticoliScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articoli = [
      'KIT CLICKIT',
      'CFFILI DI KIRSCHNER',
      'VITI UNIVERSALI IN ACCIAIO',
      'VITI STANDARD IN ACCIAIO',
      'VITI UNIVERSALI IN ACCIAIO RIVESTITE IN IDROSSIAPATITE',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARTICOLI CLICKIT CF'),
        backgroundColor: const Color(0xFFB1001A),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: articoli.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) => ListTile(
          title: Text(
            articoli[i],
            style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          leading: const Icon(Icons.medical_services, color: Color(0xFFB1001A)),
        ),
      ),
    );
  }
} 