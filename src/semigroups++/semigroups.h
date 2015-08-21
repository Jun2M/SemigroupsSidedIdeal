/*
 * Semigroups++
 *
 * This file contains the Froidure-Pin algorithm for arbitrary semigroups. 
 *
 */

// TODO
//
// 1) bit flipping for reduced?
// 6) the other functionality of Semigroupe.
// 7) rename degree to element_size or something

#ifndef SEMIGROUPS_H
#define SEMIGROUPS_H

//#define NDEBUG
//#define DEBUG

#include "basics.h"
#include "elements.h"

#include <algorithm>
#include <unordered_map>
#include <vector>
#include <assert.h>
#include <iostream>

class SemigroupBase { };

template <typename T>
class Semigroup : public SemigroupBase {
  
  typedef std::vector<size_t>     Word;
  typedef std::pair<Word*, Word*> Relation;
  typedef RecVec<size_t>          CayleyGraph;
  typedef RecVec<bool>            Flags;

  public:
    
    Semigroup& operator= (Semigroup const& copy) = delete;

    /*******************************************************************************
    ********************************************************************************
     * Constructors . . .
    ********************************************************************************
    *******************************************************************************/
    
    /*******************************************************************************
     * Construct from generators . . .
    *******************************************************************************/

    Semigroup (std::vector<T*> gens, size_t degree) : 
      _batch_size    (8192),
      _degree        (degree),
      _duplicate_gens(),
      _elements      (new std::vector<T*>()),
      _final         (),
      _first         (),    
      _found_one     (false),
      _gens          (gens), 
      _genslookup    (),
      _index         (),
      _left          (new CayleyGraph(gens.size())),
      _length        (),
      _lenindex      (), 
      _map           (), 
      _nr            (0), 
      _nrgens        (gens.size()),
      _nr_idempotents(0),
      _nrrules       (0), 
      _pos           (0), 
      _pos_one       (0), 
      _prefix        (), 
      _reduced       (Flags(gens.size())),
      _relation_pos  (-1),
      _relation_gen  (0),
      _right         (new CayleyGraph(gens.size())),
      _suffix        (), 
      _wordlen       (0) // (length of the current word) - 1
    { 
      assert(_nrgens != 0);
      
      _tmp_product = new T(degree, gens.at(0));
      _lenindex.push_back(0);
      _id = static_cast<T*>(_gens.at(0)->identity());

      // add the generators 
      for (size_t i = 0; i < _nrgens; i++) {
        T* x = _gens.at(i);
        auto it = _map.find(*x);
        if (it != _map.end()) { // duplicate generator
          _genslookup.push_back(it->second);
          _nrrules++;
          _duplicate_gens.push_back(std::make_pair(i, it->second));
        } else {
          is_one(x, _nr);
          _elements->push_back(static_cast<T*>(x->copy()));
          _first.push_back(i);
          _final.push_back(i);
          _genslookup.push_back(_nr);
          _length.push_back(1);
          _map.insert(std::make_pair(*_elements->back(), _nr));
          _prefix.push_back(-1);
          _suffix.push_back(-1);
          _index.push_back(_nr);
          _nr++;
        }
      }
      expand(_nr);
      _lenindex.push_back(_index.size()); 
    }
    
    /*******************************************************************************
     * Copy . . .
    *******************************************************************************/

    Semigroup (const Semigroup& copy)
      : _batch_size    (copy._batch_size),
        _degree        (copy._degree),    
        _duplicate_gens(copy._duplicate_gens), 
        _elements      (new std::vector<T*>()),
        _final         (copy._final),    
        _first         (copy._first),   
        _found_one     (copy._found_one),
        _genslookup    (copy._genslookup),
        _id            (static_cast<T*>(copy._id->copy())),
        _index         (copy._index),
        _left          (new CayleyGraph(copy._left)),
        _lenindex      (copy._lenindex),
        _length        (copy._length),  
        _nr            (copy._nr),
        _nrgens        (copy._nrgens),
        _nr_idempotents(copy._nr_idempotents),
        _nrrules       (copy._nrrules),
        _pos           (copy._pos),
        _pos_one       (copy._pos_one),
        _prefix        (copy._prefix), 
        _reduced       (copy._reduced),
        _relation_pos  (copy._relation_pos),
        _relation_gen  (copy._relation_gen),
        _right         (new CayleyGraph(copy._right)),
        _suffix        (copy._suffix),
        _wordlen       (copy._wordlen) 
    {
      _elements->reserve(_nr);
      _map.reserve(_nr);
      _tmp_product = new T(copy.degree(), copy.gens().at(0));

      for (size_t i = 0; i < _nrgens; i++) {
        _gens.push_back(static_cast<T*>(copy._gens.at(i)->copy()));
      }
      
      for (size_t i = 0; i < copy._elements->size(); i++) {
        _elements->push_back(static_cast<T*>(copy._elements->at(i)->copy()));
        _map.insert(std::make_pair(*_elements->back(), i));
      }
    }
 
    /*******************************************************************************
     * Construct from semigroup and additional generators . . .
    *******************************************************************************/

    Semigroup (const Semigroup& copy, const std::vector<T*>& coll, bool report)
      : _batch_size    (copy._batch_size),
        _degree        (copy._degree),    // copy for comparison in add_generators
        _duplicate_gens(copy._duplicate_gens), 
        _elements      (new std::vector<T*>()),
        _final         (copy._final),     // copy for assignment to specific positions in add_generators
                                          // FIXME get rid of this and all
                                          // others like it here!
        _first         (copy._first),     // copy for assignment to specific positions in add_generators
        _found_one     (copy._found_one), // copy in case degree doesn't change in add_generators
        _genslookup    (copy._genslookup),
        _left          (new CayleyGraph(copy._nrgens + coll.size(), copy._nr)),
        _length        (copy._length),    // copy for assignment to specific positions in add_generators
        _nr            (copy._nr),
        _nrgens        (copy._nrgens),
        _nr_idempotents(0),
        _nrrules       (0),
        _pos           (copy._pos),
        _pos_one       (copy._pos_one),   // copy in case degree doesn't change in add_generators
        _prefix        (copy._prefix),    // copy for assignment to specific positions in add_generators
        _relation_pos  (-1),
        _relation_gen  (0),
        _right         (new CayleyGraph(*copy._right)),
        _suffix        (copy._suffix),    // copy for assignment to specific positions in add_generators
        _wordlen       (0) 
    {
      assert(!coll.empty());

      _elements->reserve(copy._nr);
      _map.reserve(copy._nr);
      
      std::unordered_set<T*> new_gens;

      // remove duplicate generators
      for (T* x: coll) {
        assert(x->degree() == coll.at(0)->degree());
        new_gens.insert(x);
      }
      
      assert(!new_gens.empty());
      assert((*new_gens.begin())->degree() >= copy.degree());

      size_t deg_plus = (*new_gens.begin())->degree() - copy.degree();

      if (deg_plus != 0) { 
        _degree += deg_plus;
        _found_one = false;
        _pos_one = 0;
      } 
      
      _lenindex.push_back(0);
      _lenindex.push_back(copy._lenindex.at(1));
      _index.reserve(copy._nr);
      
      // add the distinct old generators to new _index
      for (size_t i = 0; i < copy._lenindex.at(1); i++) {
        _index.push_back(copy._index.at(i));
      }

      for (size_t i = 0; i < copy.nrgens(); i++) {
        _gens.push_back(static_cast<T*>(copy._gens.at(i)->copy(deg_plus)));
      }
      
      _id = static_cast<T*>(copy._id->copy(deg_plus));
      _tmp_product = new T(_degree, _gens.at(0));
      
      for (size_t i = 0; i < copy._elements->size(); i++) {
        _elements->push_back(static_cast<T*>(copy._elements->at(i)->T::copy(deg_plus)));
        is_one(_elements->back(), i);
        _map.insert(std::make_pair(*_elements->back(), i));
      }
      
      add_generators(new_gens, report);
    }

    /*******************************************************************************
     * Destructor . . .
    *******************************************************************************/
    
    ~Semigroup () {
      // FIXME duplicate generators are not deleted?
      delete _left;
      delete _right;
      for (T* x: *_elements) {
        x->delete_data();
        delete x;
      }
      delete _elements;
      _id->delete_data();
      delete _id;
    }
    
    /*******************************************************************************
    ********************************************************************************
     * Const methods . . .
    ********************************************************************************
    *******************************************************************************/
    
    /*******************************************************************************
     * max_word_length: get the maximum length of a current word!
    *******************************************************************************/

    size_t max_word_length () const {
      if (is_done()) {
        return _lenindex.size() - 2;
      } else if (_nr > _lenindex.back()) { 
        return _lenindex.size();
      } else {
        return _lenindex.size() - 1;
      }
    }
    
    /*******************************************************************************
     * degree: get the degree of the elements in the semigroup
    *******************************************************************************/
    
    size_t degree () const {
      return _degree;
    }
    
    /*******************************************************************************
     * nrgens: get the number of generators of the semigroup
    *******************************************************************************/
   
    size_t nrgens () const {
      return _gens.size();
    }
    
    /*******************************************************************************
     * gens: get the generators of the semigroup
    *******************************************************************************/
    
    std::vector<T*> gens () const {
      return _gens;
    }
    
    /*******************************************************************************
     * is_done: returns true if the semigroup is fully enumerated and false if not
    *******************************************************************************/
    
    bool is_done () const {
      return (_pos >= _nr);
    }
    
    /*******************************************************************************
     * is_begun: returns true if no elements (other than the generators) have
     * been enumerated
    *******************************************************************************/
    
    bool is_begun () const {
      assert(_lenindex.size() > 1);
      return (_pos >= _lenindex.at(1));
    }
    
    /*******************************************************************************
     * current_size: the number of elements enumerated so far
    *******************************************************************************/

    size_t current_size () const {
      return _elements->size();
    }
    
    size_t current_nrrules () const {
      return _nrrules;
    }
    
    size_t prefix (size_t element_nr) const {
      assert(element_nr < _nr);
      return _prefix.at(element_nr);
    }
    
    size_t suffix (size_t element_nr) const {
      assert(element_nr < _nr);
      return _suffix.at(element_nr);
    }
    
    size_t first_letter (size_t element_nr) const {
      assert(element_nr < _nr);
      return _first.at(element_nr);
    }

    size_t final_letter (size_t element_nr) const {
      assert(element_nr < _nr);
      return _final.at(element_nr);
    }
    
    size_t batch_size () const {
      return _batch_size;
    }

    /*******************************************************************************
     * length: the length of the _elements.at(pos)
    *******************************************************************************/
    
    size_t length (size_t pos) const {
      assert(pos < _nr);
      return _length.at(pos);
    }

    /*******************************************************************************
     * product_by_reduction: take the product of _elements->at(i) and
     * _elements->at(j) by tracing the Cayley graph. Assumes i, j are less than _nr.
    *******************************************************************************/
    
    size_t product_by_reduction (size_t i, size_t j) {
      assert(i < _nr && j < _nr);
      if (length(i) <= length(j)) {
          while (i != (size_t) -1) {
            j = _left->get(j, _final.at(i));
            i = _prefix.at(i);
          }
          return j;
      } else {
        while (j != (size_t) -1) {
          i = _right->get(i, _first.at(j));
          j = _suffix.at(j);
        }
        return i;
      }
    }

    //TODO write a fast_product method which figures out if
    // product_by_reduction or redefinition is faster (by using a complexity()
    // method for Elements.

    /*******************************************************************************
    ********************************************************************************
     * Non-const methods . . .  
    ********************************************************************************
    *******************************************************************************/

    /*******************************************************************************
     * nr_idempotents: get the total number of idempotents
    *******************************************************************************/

    size_t nr_idempotents (bool report) {
      if (_nr_idempotents == 0) {
        enumerate(-1, report);
        
        size_t sum_word_lengths = 0;
        for (size_t i = 1; i < _lenindex.size(); i++) {
          sum_word_lengths += i * (_lenindex.at(i) - _lenindex.at(i - 1));
        }
          
        if (_nr * _tmp_product->complexity() < sum_word_lengths) {
          for (size_t i = 0; i < _nr; i++) {
            _tmp_product->redefine(_elements->at(i), _elements->at(i));
            if (*_tmp_product == *_elements->at(i)) {
              _nr_idempotents++;
            }
          }
        } else {
          for (size_t i = 0; i < _nr; i++) {
            if (product_by_reduction(i, i) == i) {
              _nr_idempotents++;
            }
          }
        }
      }
      return _nr_idempotents;
    }

    size_t nrrules (bool report) {
      enumerate(-1, report);
      return _nrrules;
    }

    void set_batch_size (size_t batch_size) {
      _batch_size = batch_size;
    }

    size_t size (bool report) {
      enumerate(-1, report);
      return _elements->size();
    }
    
    /*******************************************************************************
     * test_membership: check if the element x belongs to the semigroup
    *******************************************************************************/

    size_t test_membership (T* x, bool report) {
      return (position(x) != (size_t) -1);
    }

    size_t position (T* x, bool report) {
      if (x->degree() != _degree) {
        return -1;
      }

      while (true) { 
        auto it = _map.find(*x);
        if (it != _map.end()) {
          return it->second;
        }
        if (is_done()) {
          return -1;
        }
        enumerate(_nr + 1, report); 
        // the _nr means we enumerate _batch_size more elements
      }
    }

    std::vector<T*>* elements (size_t limit, bool report) {
      enumerate(limit, report);
      return _elements;
    }
    
    RecVec<size_t>* right_cayley_graph (bool report) {
      enumerate(-1, report);
      return _right;
    }
    
    RecVec<size_t>* left_cayley_graph (bool report) {
      enumerate(-1, report);
      return _left;
    }
    
    Word* factorisation (size_t pos, bool report) { 
      // factorisation of _elements.at(pos)

      Word* word = new Word();
      if (pos > _nr && !is_done()) {
        enumerate(pos, report);
      }
      
      if (pos < _nr) {
        while (pos != (size_t) -1) {
          word->push_back(_first.at(pos));
          pos = _suffix.at(pos);
        }
      }
      return word;
    }
    
    void reset_next_relation () {
      _relation_pos = -1;
      _relation_gen = 0;
    }

    // Modifies <relation> in place so that 
    //
    // _elements(relation.at(0)) * _gens(relation.at(1) =
    // _elements(relation.at(2))
    //
    // <relation> is empty if there are no more relations, and it has length 2
    // in the special case of duplicate generators.
    
    void next_relation (std::vector<size_t>& relation, bool report) {
      if (!is_done()) {
        enumerate(-1, report);
      }
      
      relation.clear();
      
      if (_relation_pos == _nr) { //no more relations
        return;
      }
    
      if (_relation_pos != (size_t) -1) {
        while (_relation_pos < _nr) {
          while (_relation_gen < _nrgens) {
            if (!_reduced.get(_index.at(_relation_pos), _relation_gen) 
                && (_relation_pos < _lenindex.at(1) || 
                    _reduced.get(_suffix.at(_index.at(_relation_pos)),
                                            _relation_gen))) {
              relation.push_back(_index.at(_relation_pos));
              relation.push_back(_relation_gen);
              relation.push_back(_right->get(_index.at(_relation_pos), _relation_gen));
              break;
            }
            _relation_gen++;
          }
          if (relation.empty()) {
            _relation_gen = 0;
            _relation_pos++;
          } else {
            break;
          }
        }
        if (_relation_gen == _nrgens) {
          _relation_gen = 0;
          _relation_pos++;
        } else {
          _relation_gen++;
        }
      } else {
        //duplicate generators
        if (_relation_gen < _duplicate_gens.size()) {
          relation.push_back(_duplicate_gens.at(_relation_gen).first);
          relation.push_back(_duplicate_gens.at(_relation_gen).second);
          _relation_gen++;
        } else {
          _relation_gen = 0;
          _relation_pos++;
          next_relation(relation, report);
        }
      }
    }
   
    void enumerate (size_t limit, bool report) {
      if (_pos >= _nr || limit <= _nr) return;
      limit = std::max(limit, _nr + _batch_size);
      
      if (report) {
        std::cout << "semigroups++: enumerate" << std::endl;
        std::cout << "limit = " << limit << std::endl;
      }
      
      // pass in sample object to, for example, pass on the semiring for
      // MatrixOverSemiring

      //multiply the generators by every generator
      if (_pos < _lenindex.at(1)) {
        size_t nr_shorter_elements = _nr;
        while (_pos < _lenindex.at(1)) { 
          size_t i = _index.at(_pos);
          for (size_t j = 0; j < _nrgens; j++) {
            _tmp_product->redefine(_elements->at(i), _gens.at(j)); 
            auto it = _map.find(*_tmp_product); 

            if (it != _map.end()) {
              _right->set(i, j, it->second);
              _nrrules++;
            } else {
              is_one(_tmp_product, _nr);
              _elements->push_back(static_cast<T*>(_tmp_product->copy()));
              _first.push_back(_first.at(i));
              _final.push_back(j);
              _index.push_back(_nr);
              _length.push_back(2);
              _map.insert(std::make_pair(*_elements->back(), _nr));
              _prefix.push_back(i);
              _reduced.set(i, j, true);
              _right->set(i, j, _nr);
              _suffix.push_back(_genslookup.at(j));
              _nr++;
            }
          }
          _pos++;
        }
        for (size_t i = 0; i < _pos; i++) { 
          size_t b = _final.at(_index.at(i)); 
          for (size_t j = 0; j < _nrgens; j++) { 
            _left->set(_index.at(i), j, _right->get(_genslookup.at(j), b));
          }
        }
        _wordlen++;
        expand(_nr - nr_shorter_elements);
        _lenindex.push_back(_index.size()); 
      }

      //multiply the words of length > 1 by every generator
      bool stop = (_nr >= limit);

      while (_pos < _nr && !stop) {
        size_t nr_shorter_elements = _nr;
        while (_pos < _lenindex.at(_wordlen + 1) && !stop) {
          size_t i = _index.at(_pos);
          size_t b = _first.at(i);
          size_t s = _suffix.at(i);
          for (size_t j = 0; j < _nrgens; j++) {
            if (!_reduced.get(s, j)) {
              size_t r = _right->get(s, j);
              if (_found_one && r == _pos_one) {
                _right->set(i, j, _genslookup.at(b));
              } else if (_prefix.at(r) != (size_t) -1) { // r is not a generator
                _right->set(i, j, _right->get(_left->get(_prefix.at(r), b),
                                              _final.at(r)));
              } else { 
                _right->set(i, j, _right->get(_genslookup.at(b), _final.at(r)));
              } 
            } else {
              _tmp_product->redefine(_elements->at(i), _gens.at(j)); 
              auto it = _map.find(*_tmp_product); 

              if (it != _map.end()) {
                _right->set(i, j, it->second);
                _nrrules++;
              } else {
                is_one(_tmp_product, _nr);
                _elements->push_back(static_cast<T*>(_tmp_product->copy()));
                _first.push_back(b);
                _final.push_back(j);
                _length.push_back(_wordlen + 2);
                _map.insert(std::make_pair(*_elements->back(), _nr));
                _prefix.push_back(i);
                _reduced.set(i, j, true);
                _right->set(i, j, _nr);
                _suffix.push_back(_right->get(s, j));
                _index.push_back(_nr);
                _nr++;
                stop = (_nr >= limit);
              }
            }
          } // finished applying gens to <_elements->at(_pos)>
          _pos++;
        } // finished words of length <wordlen> + 1
        expand(_nr - nr_shorter_elements);

        if (_pos > _nr || _pos == _lenindex.at(_wordlen + 1)) {
          for (size_t i = _lenindex.at(_wordlen); i < _pos; i++) { 
            size_t p = _prefix.at(_index.at(i));
            size_t b = _final.at(_index.at(i)); 
            for (size_t j = 0; j < _nrgens; j++) { 
              _left->set(_index.at(i), j, _right->get(_left->get(p, j), b));
            }
          }
          _wordlen++;
          _lenindex.push_back(_index.size()); 
        }
        if (report) {
          std::cout << "found " << _nr << " elements, ";
          std::cout << _nrrules << " rules, ";
          std::cout << "max word length " << max_word_length();
          if (!is_done()) {
            std::cout << ", so far" << std::endl;
          } else {
            std::cout << ", finished!" << std::endl;
          }

        }
      }
    }
    
    // add generators to <this>, use whatever information is already known.
    
    void add_generators (const std::unordered_set <T*>&  coll, 
                         bool                            report) {
      if (report) {
        std::cout << "semigroups++: add_generators" << std::endl;
      }

      if (coll.empty()) {
        return;
      }

      assert(degree() == (*coll.begin())->degree()); 
      
      // get some parameters from the old semigroup
      size_t old_nrgens  = _nrgens; 
      size_t old_pos     = _pos;
      size_t old_nr      = _nr;
      size_t nr_old_left = _nr;
      
      std::vector<bool> old_new; // have we seen _elements->at(i) yet in new?
      old_new.reserve(old_nr);
      for (size_t i = 0; i < old_nr; i++) {
        old_new.push_back(false);
      }
      for (size_t i = 0; i < _genslookup.size(); i++) {
        old_new.at(_genslookup.at(i)) = true;
        nr_old_left--;
      }

      // reset the data structure 1/2
      _nrrules = _duplicate_gens.size();
      _pos = 0;
      _index.erase(_index.begin() + _lenindex.at(1), _index.end());
      _wordlen = 0;
      
      // add the new generators to new _gens, elements, and _index
      for (T* x: coll) {
        if (_map.find(*x) == _map.end()) {
          _first.push_back(_gens.size());
          _final.push_back(_gens.size());

          _gens.push_back(x);
          _elements->push_back(x);
          _genslookup.push_back(_nr);
          _index.push_back(_nr);

          is_one(x, _nr);
          _map.insert(std::make_pair(*x, _nr));
          _prefix.push_back(-1);
          _suffix.push_back(-1);
          _length.push_back(1);
          
          _nr++;
        }
      }
      
      // reset the data structure 2/2
      _nrgens = _gens.size();
      _lenindex.clear();
      _lenindex.push_back(0);
      _lenindex.push_back(_nrgens - _duplicate_gens.size()); 
      
      // add columns for new generators if necessary
      if (_reduced.nrcols() != _nrgens) {
        _reduced = RecVec<bool>(_nrgens, _nr);
      }
      if (_right->nrcols() != _nrgens) {
        _right = add_cols(_right, coll.size());
      }
      if (_left->nrcols() != _nrgens) {
        _left = add_cols(_left, coll.size());
      }
      
      // add rows in left/right/reduced for newly added generators
      expand(_nrgens - old_nrgens);

      size_t nr_shorter_elements;
      //T x(_degree, _gens.at(0)); 
      // pass in sample object to, for example, pass on the semiring for
      // MatrixOverSemiring

      // Multiply all elements by all generators (old and new) until we have
      // all of the elements of <old> in our new data structure. 
      while (nr_old_left > 0) {
        nr_shorter_elements = _nr;
        while (_pos < _lenindex.at(_wordlen + 1) && nr_old_left > 0) {
          size_t i = _index.at(_pos); // position in _elements
          size_t b = _first.at(i);
          size_t s = _suffix.at(i); 
          if (i < old_pos) { 
            // _elements.at(i) is in old semigroup, and its descendants are known
            for (size_t j = 0; j < old_nrgens; j++) {
              size_t k = _right->get(i, j);
              if (!old_new.at(k)) { // it's new!
                is_one(_elements->at(k), k);
                _first.at(k) = _first.at(i);
                _final.at(k) = j;
                _length.at(k) = _wordlen + 1;
                _prefix.at(k) = i;
                _reduced.set(i, j, true);
                if (_wordlen == 0) {
                  _suffix.at(k) = _genslookup.at(j);
                } else {
                  _suffix.at(k) = _right->get(s, j);
                }
                _index.push_back(k);
                old_new.at(k) = true;
                nr_old_left--;
              } else if (s == (size_t) -1 || _reduced.get(s, j)) {
                // TODO remove this clause or make it available in DEBUG mode
                // only
                _nrrules++;
              }
            }
            for (size_t j = old_nrgens; j < _nrgens; j++) {
              closure_update(i, j, b, s, old_new, nr_old_left, old_nr);
            }
            
          } else {
            // _elements.at(i) is not in old
            for (size_t j = 0; j < _nrgens; j++) {
              closure_update(i, j, b, s, old_new, nr_old_left, old_nr);
            }
          }
          _pos++;
        } // finished words of length <wordlen> + 1

        if (report) {
          std::cout << "found " << _nr << " elements, ";
          std::cout << _nrrules << " rules, ";
          std::cout << "max word length " << max_word_length() << std::endl;

        }
        expand(_nr - nr_shorter_elements);
        
        if (_wordlen == 0) {
          for (size_t i = 0; i < _pos; i++) { 
            size_t b = _final.at(_index.at(i)); 
            for (size_t j = 0; j < _nrgens; j++) { 
              _left->set(_index.at(i), j, _right->get(_genslookup.at(j), b));
            }
          }
        } else {
          for (size_t i = _lenindex.at(_wordlen); i < _pos; i++) { 
            size_t p = _prefix.at(_index.at(i));
            size_t b = _final.at(_index.at(i)); 
            for (size_t j = 0; j < _nrgens; j++) { 
              _left->set(_index.at(i), j, _right->get(_left->get(p, j), b));
            }
          }
        }
        if (_pos == _lenindex.at(_wordlen + 1)) {
          _lenindex.push_back(_index.size()); 
          _wordlen++;
          if (report) {
            std::cout << "found all words of length " << _wordlen << std::endl;
          }
        }
      }
      //x.delete_data();
    }
      
  private:
    
    RecVec<size_t>* add_cols (RecVec<size_t>* rv1, size_t nr) {
        RecVec<size_t>* rv2 = new RecVec<size_t>(*rv1, nr);
        delete rv1;
        return rv2;
    }

    void inline expand (size_t nr) {
      _left->add_rows(nr);
      _reduced.add_rows(nr);
      _right->add_rows(nr);
    }
    
    void inline closure_update (size_t i, 
                                size_t j, 
                                size_t b, 
                                size_t s, 
                                std::vector<bool>& old_new, 
                                size_t& nr_old_left, 
                                size_t old_nr) {
      if (_wordlen != 0 && !_reduced.get(s, j)) {
        size_t r = _right->get(s, j);
        if (_found_one && r == _pos_one) {
          _right->set(i, j, _genslookup.at(b));
        } else if (_prefix.at(r) != (size_t) -1) {
          _right->set(i, j, _right->get(_left->get(_prefix.at(r), b),
                                        _final.at(r)));
        } else { 
          _right->set(i, j, _right->get(_genslookup.at(b), _final.at(r)));
        } 
      } else {
        _tmp_product->redefine(_elements->at(i), _gens.at(j)); 
        auto it = _map.find(*_tmp_product); 
        if (it == _map.end()) { //it's new!
          is_one(_tmp_product, _nr);
          _elements->push_back(static_cast<T*>(_tmp_product->copy()));
          _first.push_back(b);
          _final.push_back(j);
          _length.push_back(_wordlen + 1);
          _map.insert(std::make_pair(*_elements->back(), _nr));
          _prefix.push_back(i);
          _reduced.set(i, j, true);
          _right->set(i, j, _nr);
          if (_wordlen == 0) { 
            _suffix.push_back(_genslookup.at(j));
          } else {
            _suffix.push_back(_right->get(s, j));
          }
          _index.push_back(_nr);
          _nr++;
        } else if (it->second < old_nr && !old_new.at(it->second)) {
          // we didn't process it yet!
          is_one(_tmp_product, it->second);
          _first.at(it->second) = b;
          _final.at(it->second) = j;
          _length.at(it->second) = _wordlen + 1;
          _prefix.at(it->second) = i;
          _reduced.set(i, j, true);
          _right->set(i, j, it->second);
          if (_wordlen == 0) { 
            _suffix.at(it->second) = _genslookup.at(j);
          } else {
            _suffix.at(it->second) = _right->get(s, j);
          }
          _index.push_back(it->second);
          old_new.at(it->second) = true;
          nr_old_left--;
        } else { // it->second >= old->_nr || old_new.at(it->second)
          // it's old
          _right->set(i, j, it->second);
          _nrrules++;
        }
      }
    }

    void inline is_one (T* x, size_t element_nr) {
      if (!_found_one && *x == *_id) {
        _pos_one = element_nr;
        _found_one = true;
      }
    }

    size_t                                  _batch_size;
    size_t                                  _degree;
    std::vector<std::pair<size_t, size_t> > _duplicate_gens;
    std::vector<T*>*                        _elements;
    std::vector<size_t>                     _final;
    std::vector<size_t>                     _first;
    bool                                    _found_one;
    std::vector<T*>                         _gens;
    std::vector<size_t>                     _genslookup;  
    T*                                      _id; 
    std::vector<size_t>                     _index;
    CayleyGraph*                            _left;
    std::vector<size_t>                     _length;
    std::vector<size_t>                     _lenindex;
    std::unordered_map<const T, size_t>     _map;         
    size_t                                  _nr;
    size_t                                  _nrgens;
    size_t                                  _nr_idempotents;
    size_t                                  _nrrules;
    size_t                                  _pos;
    size_t                                  _pos_one;
    std::vector<size_t>                     _prefix;
    Flags                                   _reduced;
    size_t                                  _relation_pos;
    size_t                                  _relation_gen;
    CayleyGraph*                            _right;
    std::vector<size_t>                     _suffix;
    T*                                      _tmp_product;
    size_t                                  _wordlen;
};

#endif
