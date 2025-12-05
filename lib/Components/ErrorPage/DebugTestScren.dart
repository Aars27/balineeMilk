import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/UserInfoProviders.dart';
import '../Savetoken/SaveToken.dart';

/// 🐛 DEBUG SCREEN - Use this to test if user data is being saved
class DebugTestScreen extends StatefulWidget {
  const DebugTestScreen({Key? key}) : super(key: key);

  @override
  State<DebugTestScreen> createState() => _DebugTestScreenState();
}

class _DebugTestScreenState extends State<DebugTestScreen> {
  String _debugInfo = "Tap 'Test' to check data...";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("🐛 Debug User Data"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current UserInfoProvider State
            _buildSection(
              "📱 UserInfoProvider State",
              [
                _buildInfoRow("Full Name", userInfo.fullName ?? "NULL ❌"),
                _buildInfoRow("User ID", userInfo.userId ?? "NULL ❌"),
                _buildInfoRow("Location", userInfo.currentAddress),
                _buildInfoRow("Is Loading User", userInfo.isLoadingUser.toString()),
                _buildInfoRow("Is Loading Location", userInfo.isLoadingLocation.toString()),
              ],
            ),

            SizedBox(height: 20),

            // Test Buttons
            _buildSection(
              "🧪 Test Actions",
              [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testTokenHelper,
                  icon: Icon(Icons.bug_report),
                  label: Text("Test TokenHelper"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _refreshUserInfo,
                  icon: Icon(Icons.refresh),
                  label: Text("Refresh UserInfoProvider"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testSaveData,
                  icon: Icon(Icons.save),
                  label: Text("Test Save Sample Data"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _clearAllData,
                  icon: Icon(Icons.delete),
                  label: Text("Clear All Data"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Debug Output
            _buildSection(
              "📋 Debug Output",
              [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _debugInfo,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            if (_isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isNull = value.contains("NULL");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isNull ? Colors.red : Colors.black87,
                fontWeight: isNull ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _testTokenHelper() async {
    setState(() {
      _isLoading = true;
      _debugInfo = "Testing TokenHelper...\n";
    });

    try {
      final tokenHelper = TokenHelper();

      // Get all values
      final token = await tokenHelper.getToken();
      final userId = await tokenHelper.getUserId();
      final userName = await tokenHelper.getUserName();
      final fullName = await tokenHelper.getFullName();

      String output = "🔍 TokenHelper Test Results:\n\n";
      output += "Token: ${token != null ? '${token.substring(0, 20)}...' : 'NULL ❌'}\n";
      output += "User ID: ${userId ?? 'NULL ❌'}\n";
      output += "User Name: ${userName ?? 'NULL ❌'}\n";
      output += "Full Name: ${fullName ?? 'NULL ❌'}\n\n";

      if (fullName == null) {
        output += "❌ PROBLEM FOUND!\n";
        output += "Full name is not saved in SharedPreferences.\n";
        output += "Check your login code!\n";
      } else {
        output += "✅ All data looks good!\n";
      }

      setState(() {
        _debugInfo = output;
      });
    } catch (e) {
      setState(() {
        _debugInfo = "❌ Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshUserInfo() async {
    setState(() {
      _isLoading = true;
      _debugInfo = "Refreshing UserInfoProvider...\n";
    });

    try {
      await Provider.of<UserInfoProvider>(context, listen: false).initialize();

      setState(() {
        _debugInfo = "✅ UserInfoProvider refreshed successfully!\n";
        _debugInfo += "Check the top section for updated values.";
      });
    } catch (e) {
      setState(() {
        _debugInfo = "❌ Error refreshing: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSaveData() async {
    setState(() {
      _isLoading = true;
      _debugInfo = "Saving sample data...\n";
    });

    try {
      final saved = await TokenHelper().saveAuthData(
        token: "sample_token_123456789",
        userId: "TEST_123",
        userName: "test_user",
        fullName: "Test User Name",
      );

      if (saved) {
        await Provider.of<UserInfoProvider>(context, listen: false).initialize();

        setState(() {
          _debugInfo = "✅ Sample data saved successfully!\n";
          _debugInfo += "Full Name: Test User Name\n";
          _debugInfo += "User ID: TEST_123\n\n";
          _debugInfo += "Check the top section to verify.";
        });
      } else {
        setState(() {
          _debugInfo = "❌ Failed to save sample data!";
        });
      }
    } catch (e) {
      setState(() {
        _debugInfo = "❌ Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearAllData() async {
    setState(() {
      _isLoading = true;
      _debugInfo = "Clearing all data...\n";
    });

    try {
      await TokenHelper().clearAuthData();
      Provider.of<UserInfoProvider>(context, listen: false).clearData();

      setState(() {
        _debugInfo = "✅ All data cleared!\n";
        _debugInfo += "You can now test login again.";
      });
    } catch (e) {
      setState(() {
        _debugInfo = "❌ Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}