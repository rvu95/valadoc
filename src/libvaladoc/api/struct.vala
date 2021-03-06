/* struct.vala
 *
 * Copyright (C) 2011  Florian Brosch
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Florian Brosch <flo.brosch@gmail.com>
 */

using Gee;
using Valadoc.Content;


/**
 * Represents a struct declaration.
 */
public class Valadoc.Api.Struct : TypeSymbol {
	private string? dup_function_cname;
	private string? copy_function_cname;
	private string? free_function_cname;
	private string? destroy_function_cname;
	private string? type_id;
	private string? cname;

	public Struct (Node parent, SourceFile file, string name, SymbolAccessibility accessibility,
				   SourceComment? comment, string? cname, string? type_macro_name,
				   string? type_function_name, string? type_id, string? dup_function_cname,
				   string? copy_function_cname, string? destroy_function_cname,
				   string? free_function_cname, bool is_basic_type, void* data)
	{
		base (parent, file, name, accessibility, comment, type_macro_name, null, null,
			type_function_name, is_basic_type, data);

		this.dup_function_cname = dup_function_cname;
		this.copy_function_cname = copy_function_cname;
		this.free_function_cname = free_function_cname;
		this.destroy_function_cname = destroy_function_cname;

		this.cname = cname;
	}

	/**
	 * Specifies the base struct.
	 */
	public TypeReference? base_type {
		set;
		get;
	}


	/**
	 * Returns the name of this struct as it is used in C.
	 */
	public string? get_cname () {
		return cname;
	}

	/**
	 * Returns the C symbol representing the runtime type id for this data type.
	 */
	public string? get_type_id () {
		return type_id;
	}

	/**
	 * Returns the C function name that duplicates instances of this data
	 * type.
	 */
	public string? get_dup_function_cname () {
		return dup_function_cname;
	}

	/**
	 * Returns the C function name that copies instances of this data
	 * type.
	 */
	public string? get_copy_function_cname () {
		return copy_function_cname;
	}

	/**
	 * Returns the C function name that frees instances of this data type.
	 */
	public string? get_free_function_cname () {
		return free_function_cname;
	}

	/**
	 * Returns the C function name that destroys instances of this data type.
	 */
	public string? get_destroy_function_cname () {
		return destroy_function_cname;
	}

	/**
	 * {@inheritDoc}
	 */
	public override NodeType node_type {
		get { return NodeType.STRUCT; }
	}

	/**
	 * {@inheritDoc}
	 */
	public override void accept (Visitor visitor) {
		visitor.visit_struct (this);
	}


	private Set<Struct> _known_child_structs = new TreeSet<Struct> ();

	/**
	 * Returns a list of all known structs based on this struct
	 */
	public Collection<Struct> get_known_child_structs () {
		return _known_child_structs.read_only_view;
	}

	public void register_child_struct (Struct stru) {
		if (this.base_type != null) {
			((Struct) this.base_type.data_type).register_child_struct (stru);
		}

		_known_child_structs.add (stru);
	}


	/**
	 * {@inheritDoc}
	 */
	protected override Inline build_signature () {
		var signature = new SignatureBuilder ();

		signature.append_keyword (accessibility.to_string ());
		signature.append_keyword ("struct");
		signature.append_symbol (this);

		var type_parameters = get_children_by_type (NodeType.TYPE_PARAMETER, false);
		if (type_parameters.size > 0) {
			signature.append ("<", false);
			bool first = true;
			foreach (Item param in type_parameters) {
				if (!first) {
					signature.append (",", false);
				}
				signature.append_content (param.signature, false);
				first = false;
			}
			signature.append (">", false);
		}

		if (base_type != null) {
			signature.append (":");

			signature.append_content (base_type.signature);
		}

		return signature.get ();
	}
}

